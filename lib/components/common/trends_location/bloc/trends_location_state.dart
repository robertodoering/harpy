part of 'trends_location_bloc.dart';

// todo: rename locations

abstract class TrendsLocationState extends Equatable {
  const TrendsLocationState();
}

extension TrendsLocationExtension on TrendsLocationState {
  bool get isLoading => this is LoadingTrendsLocation;

  bool get hasFailed => this is TrendsLocationLoadingFailure;

  bool get hasLocations => this is TrendsLocationLoaded;

  List<TrendsLocationData> get locations => this is TrendsLocationLoaded
      ? (this as TrendsLocationLoaded).locations
      : [];
}

/// The state when the trends locations are not loaded.
class TrendsLocationNotLoaded extends TrendsLocationState {
  const TrendsLocationNotLoaded();

  @override
  List<Object> get props => [];
}

/// The state when the trends are currently loading.
class LoadingTrendsLocation extends TrendsLocationState {
  const LoadingTrendsLocation();

  @override
  List<Object> get props => [];
}

/// The state when the trend locations are loaded.
class TrendsLocationLoaded extends TrendsLocationState {
  const TrendsLocationLoaded({
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
class TrendsLocationEmpty extends TrendsLocationState {
  const TrendsLocationEmpty();

  @override
  List<Object> get props => [];
}

/// The state when the trends locations were unable to be loaded.
class TrendsLocationLoadingFailure extends TrendsLocationState {
  const TrendsLocationLoadingFailure();

  @override
  List<Object> get props => [];
}
