import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';

/// The state while the users are loading.
class LoadingUsersState extends PaginatedState {}

/// The state when the users have been loaded.
class LoadedUsersState extends PaginatedState {}

/// The state when an error occurred while loading the users.
class FailedLoadingUsersState extends PaginatedState {}
