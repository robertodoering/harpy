part of 'list_timeline_bloc.dart';

abstract class ListTimelineState extends Equatable {
  const ListTimelineState();
}

extension ListTimelineExtension on ListTimelineState {
  bool get showLoading => this is ListTimelineLoading;

  bool get showLoadingOlder => this is ListTimelineLoadingOlder;

  bool get showNoResult => this is ListTimelineNoResult;

  bool get showError => this is ListTimelineFailure;

  bool get showReachedEnd =>
      this is ListTimelineResult &&
      !(this as ListTimelineResult).canRequestOlder;

  bool get enableRequestOlder =>
      this is ListTimelineResult &&
      (this as ListTimelineResult).canRequestOlder;

  bool get enableScroll => !showLoading;

  bool get hasTweets => timelineTweets.isNotEmpty;

  List<TweetData> get timelineTweets {
    if (this is ListTimelineResult) {
      return (this as ListTimelineResult).tweets;
    } else if (this is ListTimelineLoadingOlder) {
      return (this as ListTimelineLoadingOlder).oldResult.tweets;
    } else {
      return <TweetData>[];
    }
  }
}

/// The state when the list timeline is loading.
class ListTimelineLoading extends ListTimelineState {
  const ListTimelineLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the list tweets were successfully requested.
class ListTimelineResult extends ListTimelineState {
  const ListTimelineResult({
    required this.tweets,
    required this.maxId,
    this.canRequestOlder = true,
  });

  final List<TweetData> tweets;

  /// The max id used to request older tweets.
  final String? maxId;

  /// Whether older tweets in the likes timeline can be requested.
  final bool canRequestOlder;

  @override
  List<Object?> get props => <Object?>[
        tweets,
        maxId,
        canRequestOlder,
      ];
}

/// The state when the list tweets were successfully requested but tweets
/// exist for the list.
class ListTimelineNoResult extends ListTimelineState {
  const ListTimelineNoResult();

  @override
  List<Object> get props => <Object>[];
}

/// The state when an error occurred while requesting the list timeline.
class ListTimelineFailure extends ListTimelineState {
  const ListTimelineFailure();

  @override
  List<Object> get props => <Object>[];
}

/// The state when requesting older tweets.
class ListTimelineLoadingOlder extends ListTimelineState {
  const ListTimelineLoadingOlder({
    required this.oldResult,
  });

  final ListTimelineResult oldResult;

  @override
  List<Object> get props => <Object>[
        oldResult,
      ];
}
