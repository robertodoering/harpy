part of 'post_tweet_bloc.dart';

/// Posts the tweet for the authenticated user.
///
/// The attached media (if any) is uploaded separately before posting the tweet.
/// If the attached media is a video, it is converted beforehand to comply with
/// the twitter requirements.
class PostTweetEvent with HarpyLogger {
  const PostTweetEvent(this.text);

  final String text;

  Future<void> _uploadMedia(PostTweetBloc bloc, Emitter emit) async {
    log.fine('uploading media');

    final mediaFiles = <File>[];

    if (bloc.composeBloc.state.hasVideo) {
      final videoSource = bloc.composeBloc.state.media.first;

      emit(const ConvertingTweetVideo());

      final output = await app<MediaVideoConverter>().convertVideo(
        videoSource.path,
        videoSource.extension,
      );

      if (output != null) {
        mediaFiles.add(output);
      } else {
        emit(const ConvertingTweetVideoError());
      }
    } else {
      mediaFiles.addAll(
        bloc.composeBloc.state.media.map(
          (platformFile) => File(platformFile.path!),
        ),
      );
    }

    final mediaIds = <String>[];

    try {
      for (var i = 0; i < mediaFiles.length; i++) {
        emit(
          UploadingTweetMedia(
            index: i,
            multiple: mediaFiles.length > 1,
            type: bloc.composeBloc.state.type,
          ),
        );

        final mediaId = await app<MediaUploadService>().upload(
          mediaFiles[i],
          type: bloc.composeBloc.state.type,
        );

        if (mediaId != null) {
          mediaIds.add(mediaId);
        }
      }

      log.fine('${mediaIds.length} media uploaded');
      emit(
        TweetMediaSuccessfullyUploaded(
          previousMessage: bloc.state.message,
          previousAdditionalInfo: bloc.state.additionalInfo,
          mediaIds: mediaIds,
        ),
      );
    } catch (e, st) {
      log.severe('error while uploading media', e, st);
      emit(const UploadingTweetMediaError());
    }
  }

  Future<void> handle(PostTweetBloc bloc, Emitter emit) async {
    if (bloc.composeBloc.state.hasMedia) {
      await _uploadMedia(bloc, emit);
    }

    if (bloc.state is PostTweetErrorState) {
      // error ocurred while uploading media
      return;
    }

    log.fine('updating status');

    emit(const PostingTweet());

    List<String>? mediaIds;

    if (bloc.state is TweetMediaSuccessfullyUploaded) {
      mediaIds = (bloc.state as TweetMediaSuccessfullyUploaded).mediaIds;
    }

    // additional info that will be displayed in the dialog (e.g. error message)
    String? additionalInfo;

    final sentStatus = await app<TwitterApi>()
        .tweetService
        .update(
          status: text,
          mediaIds: mediaIds,
          attachmentUrl: bloc.composeBloc.quotedTweet?.tweetUrl,
          inReplyToStatusId: bloc.composeBloc.inReplyToStatus?.id,
          autoPopulateReplyMetadata: true,
        )
        .then((tweet) => TweetData.fromTweet(tweet))
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
      emit(TweetSuccessfullyPosted(tweet: sentStatus));
    } else {
      emit(PostingTweetError(errorMessage: additionalInfo));
    }
  }
}
