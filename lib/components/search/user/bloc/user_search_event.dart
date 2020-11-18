import 'package:dart_twitter_api/api/users/data/user.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_event.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:logging/logging.dart';

class SearchUsers extends LoadPaginatedData {
  const SearchUsers(this.query);

  final String query;

  static final Logger _log = Logger('SearchUsers');

  List<UserData> _transformResponse(List<User> users) {
    return users.map((User user) => UserData.fromUser(user)).toList();
  }

  @override
  Future<bool> loadData(PaginatedBloc paginatedBloc) async {
    final UserSearchBloc bloc = paginatedBloc as UserSearchBloc;
    bloc.lastQuery = query;

    _log.fine('searching users with $query');

    final List<UserData> users = await bloc.userService
        .usersSearch(
          q: query,
          count: 20,
          page: bloc.cursor,
          includeEntities: false,
        )
        .then(_transformResponse)
        .catchError(silentErrorHandler);

    if (users != null) {
      _log.fine('found ${users.length} users');
      bloc.users = users;
      return true;
    } else {
      return false;
    }
  }
}
