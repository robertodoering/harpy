part of 'trends_bloc.dart';

abstract class TrendsEvent extends Equatable {
  const TrendsEvent();

  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  });
}

class FindTrendsEvent extends TrendsEvent with HarpyLogger {
  const FindTrendsEvent();

  @override
  List<Object> get props => <Object>[];

  TrendsLocationData? _locationData(TrendsBloc bloc) {
    final trendsJson = bloc.trendsPreferences.trendsLocation;

    if (trendsJson.isNotEmpty) {
      try {
        return TrendsLocationData.fromJson(jsonDecode(trendsJson));
      } catch (e, st) {
        log.severe('unable to decode location from preferences', e, st);
      }
    }

    return null;
  }

  @override
  Stream<TrendsState> applyAsync({
    required TrendsState currentState,
    required TrendsBloc bloc,
  }) async* {
    log.fine('finding trends');

    yield const RequestingTrends();

    final location = _locationData(bloc);

    Future<List<Trends>?>? request;

    if (location == null) {
      // default to worldwide trends (woeid 1)
      request = bloc.trendsService.place(id: 1);
    } else {
      request = bloc.trendsService.place(id: 1);
    }

    final trends = await request.handleError(silentErrorHandler);

    if (trends != null && trends.isNotEmpty && trends.first.trends != null) {
      final sortedTrends = trends.first.trends!;
      sortedTrends.sort(
        (o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
      );

      yield FoundTrendsState(
        woeid: 1,
        trends: sortedTrends,
      );
    } else {
      yield const FindTrendsFailure();
    }
  }
}

class UpdateTrendsLocation extends TrendsEvent with HarpyLogger {
  const UpdateTrendsLocation({
    required this.location,
  });

  final TrendsLocationData location;

  @override
  List<Object> get props => <Object>[];

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
