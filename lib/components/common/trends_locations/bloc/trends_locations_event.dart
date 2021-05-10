part of 'trends_locations_bloc.dart';

abstract class TrendsLocationsEvent {
  const TrendsLocationsEvent();

  Stream<TrendsLocationsState> applyAsync({
    required TrendsLocationsState currentState,
    required TrendsLocationsBloc bloc,
  });
}

/// Loads the trend locations that are returned by twitter to request local
/// trends.
///
/// Only countries are saved in the state.
class LoadTrendsLocations extends TrendsLocationsEvent with HarpyLogger {
  const LoadTrendsLocations();

  @override
  Stream<TrendsLocationsState> applyAsync({
    required TrendsLocationsState currentState,
    required TrendsLocationsBloc bloc,
  }) async* {
    log.fine('loading trends locations');

    yield const LoadingTrendsLocations();

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
              country: location.country ?? '',
            ),
          );
        }
      }

      if (locations.isNotEmpty) {
        log.fine('found ${locations.length} trends locations');

        yield TrendsLocationsLoaded(locations: locations);
      } else {
        log.fine('found no trends locations');

        yield const TrendsLocationsEmpty();
      }
    } else {
      log.info('error finding trends locations');

      yield const TrendsLocationsLoadingFailure();
    }
  }
}
