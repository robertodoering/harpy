part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineEvent {
  const MentionsTimelineEvent();

  Future<void> handle(MentionsTimelineBloc bloc, Emitter emit);
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
  Future<void> handle(MentionsTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting initial mentions timeline');

    emit(const MentionsTimelineLoading());

    final lastViewedMention =
        app<TweetVisibilityPreferences>().lastViewedMention;

    final tweets = await app<TwitterApi>()
        .timelineService
        .mentionsTimeline(count: 200)
        .then(handleTweets)
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweet mentions');

      if (tweets.isNotEmpty) {
        emit(
          MentionsTimelineResult(
            tweets: tweets,
            newMentions: _newMentions(tweets, lastViewedMention),
          ),
        );
      } else {
        emit(const MentionsTimelineNoResults());
      }
    } else {
      emit(const MentionsTimelineFailure());
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
  Future<void> handle(MentionsTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is MentionsTimelineResult) {
      log.fine('updating viewed mentions');

      app<TweetVisibilityPreferences>().updateLastViewedMention(
        state.tweets.first,
      );

      emit(
        MentionsTimelineResult(
          tweets: state.tweets,
          newMentions: 0,
        ),
      );
    }
  }
}
