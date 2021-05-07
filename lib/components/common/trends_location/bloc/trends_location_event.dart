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
class LoadTrendsLocations extends TrendsLocationEvent {
  const LoadTrendsLocations();

  @override
  Stream<TrendsLocationState> applyAsync({
    required TrendsLocationState currentState,
    required TrendsLocationBloc bloc,
  }) async* {
    final trendsLocation =
        await bloc.trendsService.available().handleError(silentErrorHandler);

    if (trendsLocation != null) {
      final locations = <TrendsLocationData>[];

      // get all countries
      for (final location in trendsLocation
          .where((location) => location.placeType?.code == 12)) {
        if (location.woeid != null &&
            location.name != null &&
            location.placeType != null) {
          locations.add(
            TrendsLocationData(
              id: location.woeid!,
              name: location.name!,
              placeType: location.placeType!,
            ),
          );
        }
      }

      if (locations.isNotEmpty) {
        yield TrendsLocationLoaded(locations: locations);
      } else {
        yield const TrendsLocationEmpty();
      }
    } else {
      yield const TrendsLocationLoadingFailure();
    }
  }
}

@immutable
class TrendsLocationData {
  const TrendsLocationData({
    required this.id,
    required this.name,
    required this.placeType,
  });

  final int id;
  final String name;
  final PlaceType placeType;
}
