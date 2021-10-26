part of 'trends_bloc.dart';

abstract class TrendsEvent {
  const TrendsEvent();

  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  });
}

class FindTrendsEvent extends TrendsEvent with HarpyLogger {
  const FindTrendsEvent();

  @override
  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  }) async* {
    log.fine('finding trends');

    final location = TrendsLocationData.fromPreferences();

    yield RequestingTrends(location: location);

    final trends = await app<TwitterApi>()
        .trendsService
        .place(id: location.woeid)
        .handleError(silentErrorHandler);

    if (trends != null && trends.isNotEmpty && trends.first.trends != null) {
      final sortedTrends = trends.first.trends!
        ..sort(
          (o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
        );

      yield FoundTrendsState(
        woeid: 1,
        trends: sortedTrends,
        location: location,
      );
    } else {
      yield FindTrendsFailure(location: location);
    }
  }
}

class UpdateTrendsLocation extends TrendsEvent with HarpyLogger {
  const UpdateTrendsLocation({
    required this.location,
  });

  final TrendsLocationData location;

  @override
  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  }) async* {
    log.fine('updating trends location');

    try {
      bloc.trendsPreferences.trendsLocation = jsonEncode(location.toJson());
      bloc.add(const FindTrendsEvent());
    } catch (e, st) {
      log.severe('unable to update trends location', e, st);
    }
  }
}
