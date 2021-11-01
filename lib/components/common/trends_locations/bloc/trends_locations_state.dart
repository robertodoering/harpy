part of 'trends_locations_bloc.dart';

abstract class TrendsLocationsState extends Equatable {
  const TrendsLocationsState();
}

extension TrendsLocationsExtension on TrendsLocationsState {
  bool get isLoading => this is LoadingTrendsLocations;

  bool get hasFailed => this is TrendsLocationsLoadingFailure;

  bool get hasLocations => this is TrendsLocationsLoaded;

  List<TrendsLocationData> get locations => this is TrendsLocationsLoaded
      ? (this as TrendsLocationsLoaded).locations
      : [];
}

/// The state when the trends locations are not loaded.
class TrendsLocationsNotLoaded extends TrendsLocationsState {
  const TrendsLocationsNotLoaded();

  @override
  List<Object> get props => [];
}

/// The state when the trends are currently loading.
class LoadingTrendsLocations extends TrendsLocationsState {
  const LoadingTrendsLocations();

  @override
  List<Object> get props => [];
}

/// The state when the trend locations are loaded.
class TrendsLocationsLoaded extends TrendsLocationsState {
  const TrendsLocationsLoaded({
    required this.locations,
  });

  final List<TrendsLocationData> locations;

  @override
  List<Object> get props => [
        locations,
      ];
}

/// The state when the trend locations have been received but none were
/// parsed from the response.
class TrendsLocationsEmpty extends TrendsLocationsState {
  const TrendsLocationsEmpty();

  @override
  List<Object> get props => [];
}

/// The state when the trends locations were unable to be loaded.
class TrendsLocationsLoadingFailure extends TrendsLocationsState {
  const TrendsLocationsLoadingFailure();

  @override
  List<Object> get props => [];
}
