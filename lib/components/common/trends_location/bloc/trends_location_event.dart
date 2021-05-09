part of 'trends_location_bloc.dart';

abstract class TrendsLocationEvent {
  const TrendsLocationEvent();

  Stream<TrendsLocationState> applyAsync({
    required TrendsLocationState currentState,
    required TrendsLocationBloc bloc,
  });
}

/// Loads the trend locations that are returned by twitter to request local
/// trends.
///
/// Only countries are saved in the state.
class LoadTrendsLocations extends TrendsLocationEvent with HarpyLogger {
  const LoadTrendsLocations();

  @override
  Stream<TrendsLocationState> applyAsync({
    required TrendsLocationState currentState,
    required TrendsLocationBloc bloc,
  }) async* {
    log.fine('loading trends locations');

    yield const LoadingTrendsLocation();

    final trendsLocation =
        await bloc.trendsService.available().handleError(silentErrorHandler);

    if (trendsLocation != null) {
      final locations = <TrendsLocationData>[];

      // get all countries
      for (final location in trendsLocation
          .where((location) => location.placeType?.code == 12)) {
        if (location.woeid != null &&
            location.name != null &&
            location.placeType?.name != null) {
          locations.add(
            TrendsLocationData(
              woeid: location.woeid!,
              name: location.name!,
              placeType: location.placeType!.name!,
            ),
          );
        }
      }

      if (locations.isNotEmpty) {
        log.fine('found ${locations.length} trends locations');

        yield TrendsLocationLoaded(locations: locations);
      } else {
        log.fine('found no trends locations');

        yield const TrendsLocationEmpty();
      }
    } else {
      log.info('error finding trends locations');

      yield const TrendsLocationLoadingFailure();
    }
  }
}
