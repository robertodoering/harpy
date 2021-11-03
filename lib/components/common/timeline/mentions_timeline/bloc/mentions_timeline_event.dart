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

  @override
  Future<void> handle(MentionsTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting initial mentions timeline');

    emit(const MentionsTimelineLoading());

    final lastViewedMention =
        app<TweetVisibilityPreferences>().lastViewedMention;

    int? newestMentionId;

    final tweets = await app<TwitterApi>()
        .timelineService
        .mentionsTimeline(count: 200)
        .then((tweets) {
      if (tweets.isNotEmpty) {
        newestMentionId = int.tryParse(
          TweetData.fromTweet(tweets.first).originalId,
        );
      }

      return handleTweets(tweets);
    }).handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweet mentions');

      if (tweets.isNotEmpty) {
        emit(
          MentionsTimelineResult(
            tweets: tweets,
            hasNewMentions: !updateViewedMention &&
                lastViewedMention != 0 &&
                lastViewedMention < (newestMentionId ?? 0),
            newestMentionId: newestMentionId,
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
/// changes the [MentionsTimelineResult.hasNewMentions] to `false`.
///
/// Only has an effect if the current state is [MentionsTimelineResult] and the
/// [MentionsTimelineResult.newestMentionId] is not `null`.
class UpdateViewedMentions extends MentionsTimelineEvent with HarpyLogger {
  const UpdateViewedMentions();

  @override
  Future<void> handle(MentionsTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is MentionsTimelineResult && state.newestMentionId != null) {
      log.fine('updating viewed mentions');

      app<TweetVisibilityPreferences>().lastViewedMention =
          state.newestMentionId!;

      emit(
        MentionsTimelineResult(
          tweets: state.tweets,
          hasNewMentions: false,
        ),
      );
    }
  }
}
