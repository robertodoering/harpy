import 'dart:io';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/media_video_converter.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

/// Posts the tweet for the authenticated user.
///
/// The attached media (if any) is uploaded separately before posting the tweet.
/// If the attached media is a video, it is converted beforehand to comply with
/// the twitter requirements.
class PostTweetEvent {
  const PostTweetEvent(this.text);

  final String text;

  static final Logger _log = Logger('PostTweet');

  Stream<PostTweetState> _uploadMedia(PostTweetBloc bloc) async* {
    _log.fine('uploading media');

    final List<File> mediaFiles = <File>[];

    if (bloc.composeBloc.state.hasVideo) {
      final PlatformFile videoSource = bloc.composeBloc.state.media.first;

      yield ConvertingVideoState();

      final File output = await app<MediaVideoConverter>().convertVideo(
        videoSource.path,
        videoSource.extension,
      );

      if (output != null) {
        mediaFiles.add(output);
      } else {
        yield ConvertingVideoError();
      }
    } else {
      mediaFiles.addAll(
        bloc.composeBloc.state.media.map(
          (PlatformFile platformFile) => File(platformFile.path),
        ),
      );
    }

    try {
      for (int i = 0; i < mediaFiles.length; i++) {
        yield UploadingMediaState(
          index: i,
          multiple: mediaFiles.length > 1,
          type: bloc.composeBloc.state.type,
        );

        final String mediaId = await bloc.mediaUploadService.upload(
          mediaFiles[i],
          type: bloc.composeBloc.state.type,
        );

        if (mediaId != null) {
          bloc.mediaIds ??= <String>[];
          bloc.mediaIds.add(mediaId);
        }
      }
      _log.fine('${bloc.mediaIds?.length} media uploaded');
    } catch (e, st) {
      _log.severe('error while uploading media', e, st);
      yield UploadMediaError();
    }
  }

  Stream<PostTweetState> applyAsync({
    PostTweetState currentState,
    PostTweetBloc bloc,
  }) async* {
    if (bloc.composeBloc.state.hasMedia) {
      await for (PostTweetState state in _uploadMedia(bloc)) {
        yield state;
      }
    }

    if (bloc.state is PostTweetError) {
      return;
    }

    _log.fine('updating status');

    yield UpdatingStatusState();

    // additional info that will be displayed in the dialog (e.g. error message)
    String additionalInfo;

    final TweetData sentStatus = await bloc.tweetService
        .update(
          status: text,
          mediaIds: bloc.mediaIds,
          trimUser: true,
        )
        .then((Tweet tweet) => TweetData.fromTweet(tweet))
        .catchError((dynamic error) {
      if (error is Response) {
        final String message = responseErrorMessage(error.body);
        _log.info(
          'handling error while sending status with message $message',
          error,
        );
        additionalInfo = message;
      } else {
        silentErrorHandler(error);
      }
    });

    if (sentStatus != null) {
      yield StatusSuccessfullyUpdated();
    } else {
      yield UpdatingStatusError(errorMessage: additionalInfo);
    }
  }
}
