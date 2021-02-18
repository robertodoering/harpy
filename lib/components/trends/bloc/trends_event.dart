part of 'trends_bloc.dart';

abstract class TrendsEvent extends Equatable {
  const TrendsEvent();

  Stream<TrendsState> applyAsync({
    TrendsState currentState,
    TrendsBloc bloc,
  });
}

class FindTrendsEvent extends TrendsEvent with Logger {
  const FindTrendsEvent({
    @required this.woeid,
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
    TrendsState currentState,
    TrendsBloc bloc,
  }) async* {
    log.fine('finding trends for woeid: $woeid');

    yield const RequestingTrends();

    final List<Trends> trends = await bloc.trendsService
        .place(id: woeid)
        .catchError(silentErrorHandler);

    if (trends != null && trends.isNotEmpty) {
      final List<Trend> sortedTrends = trends.first.trends;
      sortedTrends.sort(
        (Trend o1, Trend o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
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
