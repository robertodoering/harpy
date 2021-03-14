part of 'likes_timeline_bloc.dart';

abstract class LikesTimelineState extends Equatable {
  const LikesTimelineState();
}

extension LikesTimelineExtension on LikesTimelineState {
  bool get showInitialLoading => this is LikesTimelineInitialLoading;

  bool get showLoadingOlder => this is LikesTimelineLoadingOlder;

  bool get showNoTweetsFound => this is LikesTimelineNoResult;

  bool get showTimelineError => this is LikesTimelineFailure;

  bool get showReachedEnd =>
      this is LikesTimelineResult &&
      !(this as LikesTimelineResult).canRequestOlder;

  bool get enableRequestOlder =>
      this is LikesTimelineResult &&
      (this as LikesTimelineResult).canRequestOlder;

  bool get enableScroll => !showInitialLoading;

  bool get enableFilter =>
      this is LikesTimelineResult || timelineFilter != TimelineFilter.empty;

  TimelineFilter get timelineFilter {
    if (this is LikesTimelineResult) {
      return (this as LikesTimelineResult).timelineFilter;
    } else if (this is LikesTimelineLoadingOlder) {
      return (this as LikesTimelineLoadingOlder).oldResult.timelineFilter;
    } else if (this is LikesTimelineNoResult) {
      return (this as LikesTimelineNoResult).timelineFilter;
    } else if (this is LikesTimelineFailure) {
      return (this as LikesTimelineFailure).timelineFilter;
    } else {
      return TimelineFilter.empty;
    }
  }

  List<TweetData> get timelineTweets {
    if (this is LikesTimelineResult) {
      return (this as LikesTimelineResult).tweets;
    } else if (this is LikesTimelineLoadingOlder) {
      return (this as LikesTimelineLoadingOlder).oldResult.tweets;
    } else {
      return <TweetData>[];
    }
  }
}

class LikesTimelineInitial extends LikesTimelineState {
  const LikesTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the initial likes timeline is being requested.
class LikesTimelineInitialLoading extends LikesTimelineState {
  const LikesTimelineInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the likes timeline has successfully been returned with
/// tweets.
class LikesTimelineResult extends LikesTimelineState {
  const LikesTimelineResult({
    @required this.tweets,
    @required this.timelineFilter,
    @required this.maxId,
    this.canRequestOlder = true,
  });

  final List<TweetData> tweets;

  final TimelineFilter timelineFilter;

  /// The max id used to request older tweets.
  ///
  /// This is the id of the last requested tweet before the tweets got filtered.
  final String maxId;

  /// Whether older tweets in the likes timeline can be requested.
  ///
  /// This is `false` when the end of the likes timeline has been reached.
  /// This is the case when the last 800 tweets have been requested.
  final bool canRequestOlder;

  @override
  List<Object> get props => <Object>[
        tweets,
        timelineFilter,
        maxId,
        canRequestOlder,
      ];
}

/// The state when the likes timeline has successfully been returned but no
/// tweets were found.
class LikesTimelineNoResult extends LikesTimelineState {
  const LikesTimelineNoResult({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when an error occurred while requesting the likes timeline.
class LikesTimelineFailure extends LikesTimelineState {
  const LikesTimelineFailure({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when requesting older tweets.
class LikesTimelineLoadingOlder extends LikesTimelineState {
  const LikesTimelineLoadingOlder({
    @required this.oldResult,
  });

  final LikesTimelineResult oldResult;

  @override
  List<Object> get props => <Object>[
        oldResult,
      ];
}
