part of 'user_timeline_bloc.dart';

abstract class UserTimelineState extends Equatable {
  const UserTimelineState();
}

extension UserTimelineExtension on UserTimelineState {
  bool get showInitialLoading => this is UserTimelineInitialLoading;

  bool get showLoadingOlder => this is UserTimelineLoadingOlder;

  bool get showNoTweetsFound => this is UserTimelineNoResult;

  bool get showTimelineError => this is UserTimelineFailure;

  bool get showReachedEnd =>
      this is UserTimelineResult &&
      !(this as UserTimelineResult).canRequestOlder;

  bool get enableRequestOlder =>
      this is UserTimelineResult &&
      (this as UserTimelineResult).canRequestOlder;

  bool get enableScroll => timelineTweets.isNotEmpty;

  bool get enableFilter => this is UserTimelineResult;

  TimelineFilter get timelineFilter {
    if (this is UserTimelineResult) {
      return (this as UserTimelineResult).timelineFilter;
    } else if (this is UserTimelineLoadingOlder) {
      return (this as UserTimelineLoadingOlder).oldResult.timelineFilter;
    } else if (this is UserTimelineNoResult) {
      return (this as UserTimelineNoResult).timelineFilter;
    } else if (this is UserTimelineFailure) {
      return (this as UserTimelineFailure).timelineFilter;
    } else {
      return TimelineFilter.empty;
    }
  }

  List<TweetData> get timelineTweets {
    if (this is UserTimelineResult) {
      return (this as UserTimelineResult).tweets;
    } else if (this is UserTimelineLoadingOlder) {
      return (this as UserTimelineLoadingOlder).oldResult.tweets;
    } else {
      return <TweetData>[];
    }
  }
}

class UserTimelineInitial extends UserTimelineState {
  const UserTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the initial user timeline is being requested.
class UserTimelineInitialLoading extends UserTimelineState {
  const UserTimelineInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the user timeline has successfully been returned with tweets.
class UserTimelineResult extends UserTimelineState {
  const UserTimelineResult({
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

  /// Whether older tweets in the user timeline can be requested.
  ///
  /// This is `false` when the end of the user timeline has been reached.
  /// This is the case when the last 800 tweets have been requested.
  final bool canRequestOlder;

  @override
  List<Object> get props => <Object>[
        tweets,
        timelineFilter,
        canRequestOlder,
      ];
}

/// The state when the user timeline has successfully been returned but no
/// tweets were found.
class UserTimelineNoResult extends UserTimelineState {
  const UserTimelineNoResult({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when an error occurred while requesting the user timeline.
class UserTimelineFailure extends UserTimelineState {
  const UserTimelineFailure({
    @required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];
}

/// The state when requesting older tweets.
class UserTimelineLoadingOlder extends UserTimelineState {
  const UserTimelineLoadingOlder({
    @required this.oldResult,
  });

  final UserTimelineResult oldResult;

  @override
  List<Object> get props => <Object>[
        oldResult,
      ];
}
