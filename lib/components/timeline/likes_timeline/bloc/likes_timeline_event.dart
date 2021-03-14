part of 'likes_timeline_bloc.dart';

abstract class LikesTimelineEvent extends Equatable {
  const LikesTimelineEvent();

  Stream<LikesTimelineState> applyAsync({
    LikesTimelineState currentState,
    LikesTimelineBloc bloc,
  });
}

/// Requests the likes timeline tweets for the [LikesTimelineBloc.screenName].
class RequestLikesTimeline extends LikesTimelineEvent with Logger {
  const RequestLikesTimeline({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];

  @override
  Stream<LikesTimelineState> applyAsync({
    LikesTimelineState currentState,
    LikesTimelineBloc bloc,
  }) async* {
    log.fine('requesting likes timeline');

    yield const LikesTimelineInitialLoading();

    String maxId;

    final List<TweetData> tweets = await bloc.tweetService
        .listFavorites(
          screenName: bloc.screenName,
          count: 200,
        )
        .then((List<Tweet> tweets) {
          if (tweets != null && tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then((List<Tweet> tweets) => handleTweets(tweets, timelineFilter))
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        yield LikesTimelineResult(
          tweets: tweets,
          timelineFilter: timelineFilter,
          maxId: maxId,
        );
      } else {
        yield LikesTimelineNoResult(timelineFilter: timelineFilter);
      }
    } else {
      yield LikesTimelineFailure(timelineFilter: timelineFilter);
    }
  }
}

/// An event to request older likes timeline tweets.
///
/// This is used when the end of the likes timeline has been reached and the
/// likes wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a likes timeline can be requested.
class RequestOlderLikesTimeline extends LikesTimelineEvent with Logger {
  const RequestOlderLikesTimeline();

  @override
  List<Object> get props => <Object>[];

  String _findMaxId(LikesTimelineResult state) {
    final int lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<LikesTimelineState> applyAsync({
    LikesTimelineState currentState,
    LikesTimelineBloc bloc,
  }) async* {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    if (currentState is LikesTimelineResult) {
      final String maxId = _findMaxId(currentState);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older likes timeline tweets');

      yield LikesTimelineLoadingOlder(oldResult: currentState);

      String newMaxId;
      bool canRequestOlder = false;

      final List<TweetData> tweets = await bloc.tweetService
          .listFavorites(
            screenName: bloc.screenName,
            count: 200,
            maxId: maxId,
          )
          .then((List<Tweet> tweets) {
            if (tweets != null && tweets.isNotEmpty) {
              newMaxId = tweets.last.idStr;
              canRequestOlder = true;
            } else {
              canRequestOlder = false;
            }
            return tweets;
          })
          .then((List<Tweet> tweets) =>
              handleTweets(tweets, currentState.timelineFilter))
          .catchError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');
        log.finer('can request older: $canRequestOlder');

        yield LikesTimelineResult(
          tweets: currentState.tweets.followedBy(tweets).toList(),
          maxId: newMaxId,
          timelineFilter: currentState.timelineFilter,
          canRequestOlder: canRequestOlder,
        );
      } else {
        // re-yield result state with previous tweets but new max id
        yield LikesTimelineResult(
          tweets: currentState.tweets,
          maxId: currentState.maxId,
          timelineFilter: currentState.timelineFilter,
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}
