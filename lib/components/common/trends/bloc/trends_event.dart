part of 'trends_bloc.dart';

abstract class TrendsEvent extends Equatable {
  const TrendsEvent();

  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  });
}

class FindTrendsEvent extends TrendsEvent with HarpyLogger {
  const FindTrendsEvent({
    required this.woeid,
  });

  const FindTrendsEvent.global() : this(woeid: 1);

  /// The Yahoo! Where On Earth ID of the location to return trending
  /// information for. Global information is available by using 1 as the
  /// `WOEID`.
  final int woeid;

  @override
  List<Object> get props => <Object>[
        woeid,
      ];

  @override
  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  }) async* {
    log.fine('finding trends for woeid: $woeid');

    yield const RequestingTrends();

    final trends = await bloc.trendsService
        .place(id: woeid)
        .handleError(silentErrorHandler);

    if (trends != null && trends.isNotEmpty) {
      final sortedTrends = trends.first.trends!;
      sortedTrends.sort(
        (o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
      );

      yield FoundTrendsState(
        woeid: woeid,
        trends: sortedTrends,
      );
    } else {
      yield const FindTrendsFailure();
    }
  }
}
