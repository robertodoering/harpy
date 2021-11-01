part of 'paginated_bloc.dart';

abstract class PaginatedState {}

/// The initial state of the [PaginatedBloc].
class InitialPaginatedState extends PaginatedState {}

/// The state while loading the paginated data.
///
/// This is yielded when the initial data is being loaded or when loading
/// another page.
class LoadingPaginatedData extends PaginatedState {}

/// The state when the data has been loaded.
class LoadedData extends PaginatedState {}

/// The state when an error occurred during loading the data.
class LoadingFailed extends PaginatedState {}
