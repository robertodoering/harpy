import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/compose/old_bloc/compose_bloc.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_event.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/core/api/twitter/media_upload_service.dart';
import 'package:harpy/core/service_locator.dart';

class PostTweetBloc extends Bloc<PostTweetEvent, PostTweetState> {
  PostTweetBloc(
    String text, {
    @required this.composeBloc,
  }) : super(InitialPostTweetStateState()) {
    add(PostTweetEvent(text));
  }

  final ComposeBloc composeBloc;

  final TweetService tweetService = app<TwitterApi>().tweetService;
  final MediaUploadService mediaUploadService = app<MediaUploadService>();

  static PostTweetBloc of(BuildContext context) =>
      context.watch<PostTweetBloc>();

  /// The list of uploaded media ids used to attach to the tweet.
  ///
  /// `null` when no media is being attached to the tweet.
  List<String> mediaIds;

  /// Whether the tweet is currently being posted.
  bool get inProgress =>
      state is ConvertingVideoState ||
      state is UploadingMediaState ||
      state is UpdatingStatusState;

  /// Whether the tweet has successfully been posted.
  bool get postingSuccessful => state is StatusSuccessfullyUpdated;

  /// Whether posting the tweet failed.
  bool get postingFailed => state is PostTweetError;

  @override
  Stream<PostTweetState> mapEventToState(
    PostTweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
