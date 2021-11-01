part of 'find_trends_locations_bloc.dart';

abstract class FindTrendsLocationsEvent {
  const FindTrendsLocationsEvent();

  Future<void> handle(FindTrendsLocationsBloc bloc, Emitter emit);
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
  Future<void> handle(FindTrendsLocationsBloc bloc, Emitter emit) async {
    log.fine('finding closest trends locations');

    emit(const FindTrendsLocationsLoading());

    final closest = await app<TwitterApi>()
        .trendsService
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
              country: location.country ?? '',
            ),
          );
        }
      }

      if (locations.isNotEmpty) {
        log.fine('found ${locations.length} closest trends locations');

        emit(FindTrendsLocationsLoaded(locations: locations));
      } else {
        log.fine('found no closest trends locations');

        emit(const FindTrendsLocationsEmpty());
      }
    } else {
      log.info('error finding closest trends locations');

      emit(const FindTrendsLocationsLoadingFailure());
    }
  }
}

/// Gets the current location data and adds the [FindTrendsLocations] event
/// if successful.
///
/// Requires the user to accept access to the geolocation service.
class FindNearbyLocations extends FindTrendsLocationsEvent with HarpyLogger {
  const FindNearbyLocations();

  /// Requests to enable the location service if it not enabled.
  Future<bool> _requestService(location.Location geo) async {
    var service = await geo.serviceEnabled();

    if (!service) {
      service = await geo.requestService();

      if (!service) {
        return false;
      }
    }

    return true;
  }

  /// Requests permissions to use the location service.
  Future<bool> _requestPermission(location.Location geo) async {
    var permission = await geo.hasPermission();

    if (permission == location.PermissionStatus.denied) {
      permission = await geo.requestPermission();
    }

    if (permission == location.PermissionStatus.denied ||
        permission == location.PermissionStatus.deniedForever) {
      return false;
    }

    return true;
  }

  @override
  Future<void> handle(FindTrendsLocationsBloc bloc, Emitter emit) async {
    log.fine('finding nearby locations');

    emit(const FindTrendsLocationsLoading());

    final geo = location.Location();

    try {
      if (!await _requestService(geo)) {
        log.info('location service enabling request denied');
        emit(const FindTrendsLocationsLocationServiceDisabled());
        return;
      }

      if (!await _requestPermission(geo)) {
        log.info('location permission not granted');
        emit(const FindTrendsLocationsLocationPermissionsDenied());
        return;
      }

      final locationData = await geo.getLocation();

      log.fine('got location data: $locationData');

      bloc.add(
        FindTrendsLocations(
          latitude: '${locationData.latitude}',
          longitude: '${locationData.longitude}',
        ),
      );
    } catch (e, st) {
      log.warning('unable to get current position', e, st);

      emit(const FindTrendsLocationsLoadingFailure());
    }
  }
}

/// Resets the bloc's state to the initial state.
class ClearFoundTrendsLocations extends FindTrendsLocationsEvent
    with HarpyLogger {
  const ClearFoundTrendsLocations();

  @override
  Future<void> handle(FindTrendsLocationsBloc bloc, Emitter emit) async {
    log.fine('clearing found trends locations');

    emit(const FindTrendsLocationsInitial());
  }
}
