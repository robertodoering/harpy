part of 'trends_locations_bloc.dart';

abstract class TrendsLocationsEvent {
  const TrendsLocationsEvent();

  Future<void> handle(TrendsLocationsBloc bloc, Emitter emit);
}

/// Loads the trend locations that are returned by twitter to request local
/// trends.
///
/// Only countries are saved in the state.
class LoadTrendsLocations extends TrendsLocationsEvent with HarpyLogger {
  const LoadTrendsLocations();

  @override
  Future<void> handle(TrendsLocationsBloc bloc, Emitter emit) async {
    log.fine('loading trends locations');

    emit(const LoadingTrendsLocations());

    final trendsLocation = await app<TwitterApi>()
        .trendsService
        .available()
        .handleError(silentErrorHandler);

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
        locations.sort((a, b) => a.name.compareTo(b.name));

        log.fine('found ${locations.length} trends locations');

        emit(TrendsLocationsLoaded(locations: locations));
      } else {
        log.fine('found no trends locations');

        emit(const TrendsLocationsEmpty());
      }
    } else {
      log.info('error finding trends locations');

      emit(const TrendsLocationsLoadingFailure());
    }
  }
}
