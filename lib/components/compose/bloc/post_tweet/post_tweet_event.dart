import 'dart:io';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/media_video_converter.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:logging/logging.dart';

@immutable
abstract class PostTweetEvent {
  const PostTweetEvent();

  Stream<PostTweetState> applyAsync({
    PostTweetState currentState,
    PostTweetBloc bloc,
  });
}

class PostTweet extends PostTweetEvent {
  const PostTweet(this.text);

  final String text;

  static final Logger _log = Logger('PostTweet');

  Stream<PostTweetState> _uploadMedia(PostTweetBloc bloc) async* {
    _log.fine('uploading media');

    final List<File> mediaFiles = <File>[];

    if (bloc.composeBloc.hasVideo) {
      final PlatformFile videoSource = bloc.composeBloc.media.first;

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
        bloc.composeBloc.media.map(
          (PlatformFile platformFile) => File(platformFile.path),
        ),
      );
    }

    try {
      for (int i = 0; i < mediaFiles.length; i++) {
        yield UploadingMediaState(index: i, type: bloc.composeBloc.mediaType);
        final String mediaId =
            await bloc.mediaUploadService.upload(mediaFiles[i]);

        if (mediaId != null) {
          bloc.mediaIds.add(mediaId);
        }
      }
      _log.fine('${bloc.mediaIds.length} media uploaded');
    } catch (e, st) {
      _log.severe('error while uploading media', e, st);
      yield UploadMediaError();
    }
  }

  @override
  Stream<PostTweetState> applyAsync({
    PostTweetState currentState,
    PostTweetBloc bloc,
  }) async* {
    if (bloc.composeBloc.hasMedia) {
      await for (PostTweetState state in _uploadMedia(bloc)) {
        yield state;
      }
    }

    _log.fine('updating status');

    yield UpdatingStatusState();

    final TweetData sentStatus = await bloc.tweetService
        .update(
          status: text,
          mediaIds: bloc.mediaIds,
          trimUser: true,
        )
        .then((Tweet tweet) => TweetData.fromTweet(tweet))
        .catchError(silentErrorHandler);

    if (sentStatus != null) {
      yield StatusSuccessfullyUpdated();
    } else {
      yield UpdatingStatusError();
    }
  }
}
