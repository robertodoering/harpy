import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';

/// The state while the following users are loading.
class LoadingFollowingState extends PaginatedState {}

/// The state when following users has been loaded.
class LoadedFollowingState extends PaginatedState {}

/// The state when an error occurred during loading the following users.
class FailedLoadingFollowingState extends PaginatedState {}
