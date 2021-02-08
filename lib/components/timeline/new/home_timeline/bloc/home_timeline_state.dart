part of 'home_timeline_bloc.dart';

abstract class HomeTimelineState extends Equatable {
  const HomeTimelineState();

  bool get showInitialLoading => this is HomeTimelineInitialLoading;

  bool get showLoadingOlder => this is HomeTimelineLoadingOlder;

  bool get showNoTweetsFound => this is HomeTimelineNoResult;

  bool get showSearchError => this is HomeTimelineFailure;

  bool get showReachedEnd => !enableRequestOlder;

  bool get enableRequestOlder =>
      this is HomeTimelineResult &&
      (this as HomeTimelineResult).canRequestOlder;

  bool get enableScroll => timelineTweets.isNotEmpty;

  List<TweetData> get timelineTweets {
    if (this is HomeTimelineResult) {
      return (this as HomeTimelineResult).tweets;
    } else if (this is HomeTimelineLoadingOlder) {
      return (this as HomeTimelineLoadingOlder).oldResult.tweets;
    } else {
      return <TweetData>[];
    }
  }

  bool showNewTweetsExist(String idStr) {
    HomeTimelineResult result;

    if (this is HomeTimelineResult) {
      result = this;
    } else if (this is HomeTimelineLoadingOlder) {
      result = (this as HomeTimelineLoadingOlder).oldResult;
    }

    if (result != null) {
      return result.newTweetsExist &&
          result.includesLastVisibleTweet &&
          result.lastInitialTweet == idStr;
    } else {
      return false;
    }
  }
}

class HomeTimelineInitial extends HomeTimelineState {
  const HomeTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the initial home timeline is being requested.
class HomeTimelineInitialLoading extends HomeTimelineState {
  const HomeTimelineInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the home timeline has successfully been returned with tweets.
class HomeTimelineResult extends HomeTimelineState {
  const HomeTimelineResult({
    @required this.tweets,
    @required this.includesLastVisibleTweet,
    @required this.newTweetsExist,
    this.lastInitialTweet = '',
    this.initialResults = false,
    this.canRequestOlder = true,
  });

  final List<TweetData> tweets;

  /// Whether the last visible tweet from a previous sessions is included in
  /// the results.
  ///
  /// This is `false` when the last visible tweet has been deleted or is
  /// older than the last 800 tweets in the home timeline.
  final bool includesLastVisibleTweet;

  /// Whether the initial request found new tweets that were not present in a
  /// previous session.
  final bool newTweetsExist;

  /// The idStr of that last tweet from the initial request.
  final String lastInitialTweet;

  /// Whether we requested the initial home timeline with tweets that are
  /// newer than the last visible tweet from a previous session.
  final bool initialResults;

  /// Whether older tweets in the home timeline can be requested.
  ///
  /// This is `false` when the end of the home timeline has been reached.
  /// This is the case when the last 800 tweets have been requested.
  final bool canRequestOlder;

  @override
  List<Object> get props => <Object>[
        tweets,
        includesLastVisibleTweet,
        newTweetsExist,
        lastInitialTweet,
        initialResults,
        canRequestOlder,
      ];
}

/// The state when the home timeline has successfully been returned but no
/// tweets were found.
///
/// This may happen when the user is not following anyone.
class HomeTimelineNoResult extends HomeTimelineState {
  const HomeTimelineNoResult();

  @override
  List<Object> get props => <Object>[];
}

/// The state when an error occurred while requesting the home timeline.
class HomeTimelineFailure extends HomeTimelineState {
  const HomeTimelineFailure();

  @override
  List<Object> get props => <Object>[];
}

/// The state when requesting older tweets.
class HomeTimelineLoadingOlder extends HomeTimelineState {
  const HomeTimelineLoadingOlder({
    @required this.oldResult,
  });

  final HomeTimelineResult oldResult;

  @override
  List<Object> get props => <Object>[oldResult];
}
