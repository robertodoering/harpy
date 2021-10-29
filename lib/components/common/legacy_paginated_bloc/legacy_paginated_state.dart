part of 'legacy_paginated_bloc.dart';

// TODO: remove and migrate to PaginatedCubitMixin

abstract class LegacyPaginatedState {}

/// The initial state of the [LegacyPaginatedBloc].
class InitialPaginatedState extends LegacyPaginatedState {}

/// The state while loading the paginated data.
///
/// This is yielded when the initial data is being loaded or when loading
/// another page.
class LoadingPaginatedData extends LegacyPaginatedState {}

/// The state when the data has been loaded.
class LoadedData extends LegacyPaginatedState {}

/// The state when an error occurred during loading the data.
class LoadingFailed extends LegacyPaginatedState {}
