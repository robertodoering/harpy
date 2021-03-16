part of 'home_timeline_bloc.dart';

abstract class HomeTimelineState extends Equatable {
  const HomeTimelineState();
}

extension HomeTimelineExtension on HomeTimelineState {
  bool get showInitialLoading => this is HomeTimelineInitialLoading;

  bool get showLoadingOlder => this is HomeTimelineLoadingOlder;

  bool get showNoTweetsFound => this is HomeTimelineNoResult;

  bool get showTimelineError => this is HomeTimelineFailure;

  bool get showReachedEnd =>
      this is HomeTimelineResult &&
      !(this as HomeTimelineResult).canRequestOlder;

  bool get enableRequestOlder =>
      this is HomeTimelineResult &&
      (this as HomeTimelineResult).canRequestOlder;

  bool get enableScroll => timelineTweets.isNotEmpty;

  bool get enableFilter =>
      this is HomeTimelineResult || timelineFilter != TimelineFilter.empty;

  TimelineFilter get timelineFilter {
    if (this is HomeTimelineResult) {
      return (this as HomeTimelineResult).timelineFilter;
    } else if (this is HomeTimelineLoadingOlder) {
      return (this as HomeTimelineLoadingOlder).oldResult.timelineFilter;
    } else if (this is HomeTimelineNoResult) {
      return (this as HomeTimelineNoResult).timelineFilter;
    } else if (this is HomeTimelineFailure) {
      return (this as HomeTimelineFailure).timelineFilter;
    } else {
      return TimelineFilter.empty;
    }
  }

  bool get hasTimelineFilter => timelineFilter != TimelineFilter.empty;

  List<TweetData> get timelineTweets {
    if (this is HomeTimelineResult) {
      return (this as HomeTimelineResult).tweets;
    } else if (this is HomeTimelineLoadingOlder) {
      return (this as HomeTimelineLoadingOlder).oldResult.tweets;
    } else {
      return <TweetData>[];
    }
  }

  int get newTweets {
    if (this is HomeTimelineResult) {
      return (this as HomeTimelineResult).newTweets;
    } else if (this is HomeTimelineLoadingOlder) {
      return (this as HomeTimelineLoadingOlder).oldResult.newTweets;
    } else {
      return 0;
    }
  }

  bool showNewTweetsExist(String originalIdStr) {
    HomeTimelineResult result;

    if (this is HomeTimelineResult) {
      result = this;
    } else if (this is HomeTimelineLoadingOlder) {
      result = (this as HomeTimelineLoadingOlder).oldResult;
    }

    if (result != null) {
      return result.newTweets > 0 && result.lastInitialTweet == originalIdStr;
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
    @required this.timelineFilter,
    @required this.newTweets,
    @required this.maxId,
    this.lastInitialTweet = '',
    this.initialResults = false,
    this.canRequestOlder = true,
  });

  final List<TweetData> tweets;

  final TimelineFilter timelineFilter;

  /// The number of new tweets if the initial request found new tweets that
  /// were not present in a previous session.
  final int newTweets;

  /// The max id used to request older tweets.
  ///
  /// This is the id of the last requested tweet before the tweets got filtered.
  final String maxId;

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
        timelineFilter,
        newTweets,
        maxId,
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
  const HomeTimelineNoResult({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when an error occurred while requesting the home timeline.
class HomeTimelineFailure extends HomeTimelineState {
  const HomeTimelineFailure({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when requesting older tweets.
class HomeTimelineLoadingOlder extends HomeTimelineState {
  const HomeTimelineLoadingOlder({
    @required this.oldResult,
  });

  final HomeTimelineResult oldResult;

  @override
  List<Object> get props => <Object>[
        oldResult,
      ];
}
