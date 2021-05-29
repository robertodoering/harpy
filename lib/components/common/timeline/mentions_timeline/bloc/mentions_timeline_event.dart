part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineEvent extends Equatable {
  const MentionsTimelineEvent();

  Stream<MentionsTimelineState> applyAsync({
    required MentionsTimelineState currentState,
    required MentionsTimelineBloc bloc,
  });
}

/// Requests the newest 200 mentions timeline tweets.
///
/// When the mentions timeline has been viewed, the newest mention at that
/// point will be saved in the [TweetVisibilityPreferences].
class RequestMentionsTimeline extends MentionsTimelineEvent with HarpyLogger {
  const RequestMentionsTimeline({
    this.updateViewedMention = false,
  });

  /// Whether the new mentions are considered viewed after the request
  /// succeeded.
  ///
  /// This is the case when requesting the mentions timeline in the mentions
  /// timeline view.
  final bool updateViewedMention;

  @override
  List<Object> get props => <Object>[];

  int _newMentions(List<TweetData> tweets, int lastViewedMention) {
    if (lastViewedMention == 0) {
      // first open
      return 0;
    }

    final indexOfFirstNewestTweet = tweets.lastIndexWhere(
      (tweet) => (int.tryParse(tweet.originalId) ?? 0) > lastViewedMention,
    );

    return indexOfFirstNewestTweet + 1;
  }

  @override
  Stream<MentionsTimelineState> applyAsync({
    required MentionsTimelineState currentState,
    required MentionsTimelineBloc bloc,
  }) async* {
    log.fine('requesting initial mentions timeline');

    yield const MentionsTimelineLoading();

    final lastViewedMention =
        bloc.tweetVisibilityPreferences!.lastViewedMention;

    final tweets = await bloc.timelineService
        .mentionsTimeline(count: 200)
        .then(handleTweets)
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweet mentions');

      if (tweets.isNotEmpty) {
        yield MentionsTimelineResult(
          tweets: tweets,
          newMentions: _newMentions(tweets, lastViewedMention),
        );
      } else {
        yield const MentionsTimelineNoResults();
      }
    } else {
      yield const MentionsTimelineFailure();
    }
  }
}

/// Updates the last viewed mention in the [TweetVisibilityPreferences] and
/// changes the [MentionsTimelineResult.newMentions] to 0.
///
/// Only has an effect if the current state is [MentionsTimelineResult].
class UpdateViewedMentions extends MentionsTimelineEvent with HarpyLogger {
  const UpdateViewedMentions();

  @override
  List<Object> get props => <Object>[];

  @override
  Stream<MentionsTimelineState> applyAsync({
    required MentionsTimelineState currentState,
    required MentionsTimelineBloc bloc,
  }) async* {
    if (currentState is MentionsTimelineResult) {
      log.fine('updating viewed mentions');

      bloc.tweetVisibilityPreferences!.updateLastViewedMention(
        currentState.tweets.first,
      );

      yield MentionsTimelineResult(
        tweets: currentState.tweets,
        newMentions: 0,
      );
    }
  }
}
