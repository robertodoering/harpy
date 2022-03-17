import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:humanizer/humanizer.dart';

part 'post_tweet_cubit.freezed.dart';

class PostTweetCubit extends Cubit<PostTweetState> with HarpyLogger {
  PostTweetCubit({
    required this.composeBloc,
  }) : super(const PostTweetState.inProgress());

  final ComposeBloc composeBloc;

  Future<List<String>?> _uploadMedia() async {
    log.fine('uploading media');

    final mediaFiles = <File>[];

    if (composeBloc.state.hasVideo) {
      final videoSource = composeBloc.state.media.first;

      emit(
        const PostTweetState.inProgress(
          message: 'preparing video...',
          additionalInfo: 'this may take a moment',
        ),
      );

      final output = await app<MediaVideoConverter>().convertVideo(
        videoSource.path,
        videoSource.extension,
      );

      if (output != null) {
        mediaFiles.add(output);
      } else {
        emit(
          const PostTweetState.error(
            message: 'error preparing video',
            additionalInfo: 'the video format may not be supported',
          ),
        );
      }
    } else {
      mediaFiles.addAll(
        composeBloc.state.media.map((platformFile) => File(platformFile.path!)),
      );
    }

    final mediaIds = <String>[];

    try {
      for (var i = 0; i < mediaFiles.length; i++) {
        emit(
          PostTweetState.inProgress(
            message: composeBloc.state.type.asMessage(i, mediaFiles.length > 1),
            additionalInfo: 'this may take a moment',
          ),
        );

        final mediaId = await app<MediaUploadService>().upload(
          mediaFiles[i],
          type: composeBloc.state.type,
        );

        if (mediaId != null) {
          mediaIds.add(mediaId);
        }
      }

      log.fine('${mediaIds.length} media uploaded');
      return mediaIds;
    } catch (e, st) {
      log.severe('error while uploading media', e, st);
      emit(const PostTweetState.error(message: 'error uploading media'));
    }

    return null;
  }

  Future<void> post(String text) async {
    List<String>? mediaIds;

    if (composeBloc.state.hasMedia) {
      mediaIds = await _uploadMedia();
    }

    if (state is _Error) {
      // error ocurred while uploading media
      return;
    }

    log.fine('updating status');

    emit(const PostTweetState.inProgress(message: 'sending tweet...'));

    // additional info that will be displayed in the dialog (e.g. error message)
    String? additionalInfo;

    final sentStatus = await app<TwitterApi>()
        .tweetService
        .update(
          status: text,
          mediaIds: mediaIds,
          attachmentUrl: composeBloc.quotedTweet?.tweetUrl,
          inReplyToStatusId: composeBloc.inReplyToStatus?.id,
          autoPopulateReplyMetadata: false,
        )
        .then(TweetData.fromTweet)
        .handleError((dynamic error, stackTrace) {
      if (error is Response) {
        final message = responseErrorMessage(error.body);
        log.info(
          'handling error while sending status with message $message',
          error,
        );
        additionalInfo = message;
      } else {
        silentErrorHandler(error);
      }
    });

    if (sentStatus != null) {
      emit(
        PostTweetState.success(
          message: 'tweet successfully sent!',
          tweet: sentStatus,
        ),
      );
    } else {
      emit(
        PostTweetState.error(
          message: 'error sending tweet',
          additionalInfo: additionalInfo != null
              ? 'twitter error message:\n'
                  '$additionalInfo'
              : null,
        ),
      );
    }
  }
}

extension on MediaType? {
  String asMessage(int index, bool multiple) {
    switch (this) {
      case MediaType.image:
        return multiple
            ? 'uploading ${(index + 1).toOrdinalNumerical()} image...'
            : 'uploading image...';
      case MediaType.gif:
        return 'uploading gif...';
      case MediaType.video:
        return 'uploading video...';
      case null:
        return 'uploading media...';
    }
  }
}

@freezed
class PostTweetState with _$PostTweetState {
  const factory PostTweetState.inProgress({
    String? message,
    String? additionalInfo,
  }) = _InProgress;

  const factory PostTweetState.success({
    required TweetData tweet,
    String? message,
    String? additionalInfo,
  }) = _Success;

  const factory PostTweetState.error({
    String? message,
    String? additionalInfo,
  }) = _Error;
}

extension PostTweetStateExtension on PostTweetState {
  bool get inProgress => this is _InProgress;

  TweetData? get tweet => maybeMap(
        success: (value) => value.tweet,
        orElse: () => null,
      );
}
