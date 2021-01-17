import 'package:dart_twitter_api/api/users/data/user.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_event.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:logging/logging.dart';

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

  final String query;

  static final Logger _log = Logger('SearchUsers');

  List<UserData> _transformResponse(List<User> users) {
    return users.map((User user) => UserData.fromUser(user)).toList();
  }

  List<UserData> _filterDuplicates(
    List<UserData> oldUsers,
    List<UserData> newUsers,
  ) {
    final List<UserData> filteredUsers = List<UserData>.of(newUsers);

    for (UserData loadedUser in oldUsers) {
      for (UserData newUser in newUsers) {
        if (loadedUser.idStr == newUser.idStr) {
          filteredUsers.removeWhere(
            (UserData filteredUser) => filteredUser.idStr == newUser.idStr,
          );
        }
      }
    }

    return filteredUsers;
  }

  @override
  Future<bool> loadData(PaginatedBloc paginatedBloc) async {
    final UserSearchBloc bloc = paginatedBloc as UserSearchBloc;

    bloc.lastQuery = query;

    _log.fine('searching users with $query for page ${bloc.cursor}');

    List<UserData> users = await bloc.userService
        .usersSearch(
          q: query,
          count: 20,
          page: bloc.cursor,
          includeEntities: false,
        )
        .then(_transformResponse)
        .catchError((dynamic error) => bloc.silentErrors
            ? silentErrorHandler(error)
            : twitterApiErrorHandler(error));

    if (users != null) {
      users = _filterDuplicates(bloc.users, users);

      _log.fine('found ${users.length} users');

      if (users.length < 5) {
        // assume last page requested
        bloc.cursor = 0;
      } else {
        bloc.cursor++;
      }

      bloc.users.addAll(users);
      return true;
    } else {
      return false;
    }
  }
}

/// An event to clear the previously searched users..
class ClearSearchedUsers extends PaginatedEvent {
  const ClearSearchedUsers();

  static final Logger _log = Logger('ClearSearchedUsers');

  @override
  Stream<PaginatedState> applyAsync({
    PaginatedState currentState,
    PaginatedBloc bloc,
  }) async* {
    final UserSearchBloc userSearchBloc = bloc as UserSearchBloc;

    _log.fine('clearing searched users');

    userSearchBloc.lockRequests = false;
    userSearchBloc.cursor = 1;
    userSearchBloc.users.clear();
    userSearchBloc.lastQuery = null;

    yield InitialState();
  }
}
