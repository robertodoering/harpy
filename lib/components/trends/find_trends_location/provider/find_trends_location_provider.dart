import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:location/location.dart' as location;
import 'package:rby/rby.dart';

part 'find_trends_location_provider.freezed.dart';

final findTrendsLocationProvider = StateNotifierProvider.autoDispose<
    FindTrendsLocationNotifier, FindTrendsLocationState>(
  (ref) => FindTrendsLocationNotifier(
    twitterApi: ref.watch(twitterApiV1Provider),
  ),
  name: 'FindTrendsLocationProvider',
);

class FindTrendsLocationNotifier extends StateNotifier<FindTrendsLocationState>
    with LoggerMixin {
  FindTrendsLocationNotifier({
    required TwitterApi twitterApi,
  })  : _twitterApi = twitterApi,
        super(const FindTrendsLocationState.initial());

  final TwitterApi _twitterApi;

  Future<void> search({
    required String latitude,
    required String longitude,
  }) async {
    log.fine('finding trends at lat: $latitude, long: $longitude');

    state = const FindTrendsLocationState.loading();

    final closest = await _twitterApi.trendsService
        .closest(lat: latitude, long: longitude)
        .handleError(logErrorHandler);

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

      if (!locations.contains(TrendsLocationData.worldwide())) {
        locations.insert(0, TrendsLocationData.worldwide());
      }

      log.fine('found ${locations.length} closest trends locations');

      state = FindTrendsLocationState.data(
        locations: locations.toBuiltList(),
      );
    } else {
      log.info('error finding closest trends locations');

      state = const FindTrendsLocationState.error();
    }
  }

  Future<void> nearby() async {
    log.fine('finding nearby locations');

    state = const FindTrendsLocationState.loading();

    final geo = location.Location();

    try {
      if (!await _requestService(geo)) {
        log.info('location service request not granted');
        state = const FindTrendsLocationState.serviceDisabled();
        return;
      }

      if (!await _requestPermission(geo)) {
        log.info('location permission not granted');
        state = const FindTrendsLocationState.permissionDenied();
        return;
      }

      final locationData = await geo.getLocation();

      log.fine('got location data: $locationData');

      await search(
        latitude: '${locationData.latitude}',
        longitude: '${locationData.longitude}',
      );
    } catch (e, st) {
      log.warning('unable to get current position', e, st);

      state = const FindTrendsLocationState.error();
    }
  }

  /// Requests to enable the location service if it not enabled.
  Future<bool> _requestService(location.Location geo) async {
    var service = await geo.serviceEnabled();

    if (!service) {
      service = await geo.requestService();

      if (!service) return false;
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
}

@freezed
class FindTrendsLocationState with _$FindTrendsLocationState {
  const factory FindTrendsLocationState.initial() = _Initial;
  const factory FindTrendsLocationState.loading() = _Loading;

  const factory FindTrendsLocationState.data({
    required BuiltList<TrendsLocationData> locations,
  }) = _Data;

  const factory FindTrendsLocationState.error() = _Error;
  const factory FindTrendsLocationState.serviceDisabled() = _ServiceDisabled;
  const factory FindTrendsLocationState.permissionDenied() = _PermissionDenied;
}
