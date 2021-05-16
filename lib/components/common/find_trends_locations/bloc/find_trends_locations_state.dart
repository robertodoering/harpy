part of 'find_trends_locations_bloc.dart';

abstract class FindTrendsLocationsState extends Equatable {
  const FindTrendsLocationsState();
}

extension FindTrendsLocationsExtension on FindTrendsLocationsState {
  bool get hasLoadedData => this is! FindTrendsLocationsInitial;

  bool get isLoading => this is FindTrendsLocationsLoading;

  bool get hasLocations => this is FindTrendsLocationsLoaded;

  bool get hasServiceDisabled =>
      this is FindTrendsLocationsLocationServiceDisabled;

  bool get hasPermissionsDenied =>
      this is FindTrendsLocationsLocationPermissionsDenied;

  List<TrendsLocationData> get locations => this is FindTrendsLocationsLoaded
      ? (this as FindTrendsLocationsLoaded).locations
      : [];
}

class FindTrendsLocationsInitial extends FindTrendsLocationsState {
  const FindTrendsLocationsInitial();

  @override
  List<Object> get props => [];
}

/// The state when trends locations are currently loading.
class FindTrendsLocationsLoading extends FindTrendsLocationsState {
  const FindTrendsLocationsLoading();

  @override
  List<Object> get props => [];
}

/// The state when trends locations have been loaded.
class FindTrendsLocationsLoaded extends FindTrendsLocationsState {
  const FindTrendsLocationsLoaded({
    required this.locations,
  });

  final List<TrendsLocationData> locations;

  @override
  List<Object> get props => [
        locations,
      ];
}

/// The state when trends locations have been requested but none found.
class FindTrendsLocationsEmpty extends FindTrendsLocationsState {
  const FindTrendsLocationsEmpty();

  @override
  List<Object> get props => [];
}

/// The state when trends locations were unable to be requested.
class FindTrendsLocationsLoadingFailure extends FindTrendsLocationsState {
  const FindTrendsLocationsLoadingFailure();

  @override
  List<Object> get props => [];
}

/// The state when the geolocation service is not enabled.
class FindTrendsLocationsLocationServiceDisabled
    extends FindTrendsLocationsState {
  const FindTrendsLocationsLocationServiceDisabled();

  @override
  List<Object> get props => [];
}

/// The state when the location permissions have been denied.
class FindTrendsLocationsLocationPermissionsDenied
    extends FindTrendsLocationsState {
  const FindTrendsLocationsLocationPermissionsDenied();

  @override
  List<Object> get props => [];
}
