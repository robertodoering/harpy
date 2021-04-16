part of 'list_timeline_bloc.dart';

abstract class ListTimelineState extends Equatable {
  const ListTimelineState();
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
    @required this.tweets,
  });

  final List<TweetData> tweets;

  @override
  List<Object> get props => <Object>[
        tweets,
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
