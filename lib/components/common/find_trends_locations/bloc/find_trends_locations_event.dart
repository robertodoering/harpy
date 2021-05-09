part of 'find_trends_locations_bloc.dart';

abstract class FindTrendsLocationsEvent {
  const FindTrendsLocationsEvent();

  Stream<FindTrendsLocationsState> applyAsync({
    required FindTrendsLocationsState currentState,
    required FindTrendsLocationsBloc bloc,
  });
}

/// Finds trends locations that are close to the [latitude] and [longitude]
/// coordinates.
class FindTrendsLocations extends FindTrendsLocationsEvent with HarpyLogger {
  const FindTrendsLocations({
    required this.latitude,
    required this.longitude,
  });

  final String latitude;
  final String longitude;

  @override
  Stream<FindTrendsLocationsState> applyAsync({
    required FindTrendsLocationsState currentState,
    required FindTrendsLocationsBloc bloc,
  }) async* {
    log.fine('finding closest trends locations');

    yield const FindTrendsLocationsLoading();

    final closest = await bloc.trendsService
        .closest(lat: latitude, long: longitude)
        .handleError(silentErrorHandler);

    if (closest != null) {
      final locations = <TrendsLocationData>[];

      for (final location in closest) {
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
        log.fine('found ${locations.length} closest trends locations');

        yield FindTrendsLocationsLoaded(locations: locations);
      } else {
        log.fine('found no closest trends locations');

        yield const FindTrendsLocationsEmpty();
      }
    } else {
      log.info('error finding closest trends locations');

      yield const FindTrendsLocationsLoadingFailure();
    }
  }
}

/// Resets the bloc's state to the initial state.
class ClearFoundTrendsLocations extends FindTrendsLocationsEvent
    with HarpyLogger {
  const ClearFoundTrendsLocations();

  @override
  Stream<FindTrendsLocationsState> applyAsync({
    required FindTrendsLocationsState currentState,
    required FindTrendsLocationsBloc bloc,
  }) async* {
    log.fine('clearing found trends locations');

    yield const FindTrendsLocationsInitial();
  }
}
