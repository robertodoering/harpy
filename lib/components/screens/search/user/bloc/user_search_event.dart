part of 'user_search_bloc.dart';

/// Searches users based on the [query].
///
/// 20 users are returned per call. Subsequent [SearchUsers] events will
/// request the following users.
///
/// Sometimes the Twitter api returns less than 20 new users and when the
/// last page has been requested, following pages will return duplicate users.
/// To work around this, on every request duplicate duplicate users are
/// filtered and once only a small number of new users have been received we
/// assume no more users can be requested.
class SearchUsers extends LoadPaginatedData {
  const SearchUsers(this.query);

  final String? query;

  static final Logger _log = Logger('SearchUsers');

  List<UserData> _transformResponse(List<User> users) {
    return users.map((user) => UserData.fromUser(user)).toList();
  }

  List<UserData> _filterDuplicates(
    List<UserData> oldUsers,
    List<UserData> newUsers,
  ) {
    final filteredUsers = List<UserData>.of(newUsers);

    for (final loadedUser in oldUsers) {
      for (final newUser in newUsers) {
        if (loadedUser.id == newUser.id) {
          filteredUsers.removeWhere(
            (filteredUser) => filteredUser.id == newUser.id,
          );
        }
      }
    }

    return filteredUsers;
  }

  @override
  Future<bool> loadData(PaginatedBloc paginatedBloc) async {
    final bloc = paginatedBloc as UserSearchBloc;

    bloc.lastQuery = query;

    _log.fine('searching users with $query for page ${bloc.cursor}');

    var users = await bloc.userService
        .usersSearch(
          q: query!,
          count: 20,
          page: bloc.cursor,
          includeEntities: false,
        )
        .then(_transformResponse)
        .handleError((dynamic error, stackTrace) {
      bloc.silentErrors
          ? silentErrorHandler(error, stackTrace)
          : twitterApiErrorHandler(error, stackTrace);
    });

    if (users != null) {
      users = _filterDuplicates(bloc.users, users);

      _log.fine('found ${users.length} users');

      if (users.length < 5) {
        // assume last page requested
        bloc.cursor = 0;
      } else {
        bloc.cursor = bloc.cursor! + 1;
      }

      bloc.users.addAll(users);
      return true;
    } else {
      return false;
    }
  }
}

/// An event to clear the previously searched users.
class ClearSearchedUsers extends PaginatedEvent {
  const ClearSearchedUsers();

  static final Logger _log = Logger('ClearSearchedUsers');

  @override
  Stream<PaginatedState> applyAsync({
    required PaginatedState currentState,
    required PaginatedBloc bloc,
  }) async* {
    final userSearchBloc = bloc as UserSearchBloc;

    _log.fine('clearing searched users');

    userSearchBloc.lockRequests = false;
    userSearchBloc.cursor = 1;
    userSearchBloc.users.clear();
    userSearchBloc.lastQuery = null;

    yield InitialPaginatedState();
  }
}
