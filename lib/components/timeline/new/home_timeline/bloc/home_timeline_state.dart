part of 'home_timeline_bloc.dart';

abstract class HomeTimelineState extends Equatable {
  const HomeTimelineState();
}

class HomeTimelineInitial extends HomeTimelineState {
  const HomeTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}

class HomeTimelineInitialLoading extends HomeTimelineState {
  const HomeTimelineInitialLoading();

  @override
  List<Object> get props => <Object>[];
}

class HomeTimelineResult extends HomeTimelineState {
  const HomeTimelineResult({
    @required this.tweets,
    @required this.lastInitialTweet,
    @required this.includesLastVisibleTweet,
    this.initialResults = false,
    this.canRequestOlder = true,
  });

  final List<TweetData> tweets;

  /// The idStr of that last tweet from the initial request.
  final String lastInitialTweet;

  /// Whether the last visible tweet from a previous sessions is included in
  /// the results.
  ///
  /// This is `false` when the last visible tweet has been deleted or is
  /// older than the last 800 tweets in the home timeline.
  final bool includesLastVisibleTweet;

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
      ];
}

class HomeTimelineNoResult extends HomeTimelineState {
  const HomeTimelineNoResult();

  @override
  List<Object> get props => <Object>[];
}

class HomeTimelineFailure extends HomeTimelineState {
  const HomeTimelineFailure();

  @override
  List<Object> get props => <Object>[];
}
