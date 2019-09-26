import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/paginated_model.dart';
import 'package:harpy/models/user_search_history_model.dart';
import 'package:logging/logging.dart';

class UserSearchModel extends ChangeNotifier with PaginatedModel {
  UserSearchModel({
    @required this.query,
    @required this.userSearchHistoryModel,
  }) {
    initialize();
    _addToSearchHistory();
  }

  final UserService _userService = app<UserService>();

  final UserSearchHistoryModel userSearchHistoryModel;

  /// The query used to search for users.
  final String query;

  static final Logger _log = Logger("UserSearchModel");

  /// The list of [User]s that match the [query].
  ///
  /// Only 20 users are searched for at a time.
  final List<User> _users = [];
  List<User> get users => UnmodifiableListView(_users);

  /// Whether or not no users have been found.
  bool get noUsersFound => !loading && _users.isEmpty;

  /// The current page to request.
  int _page = 1;

  /// Uses the [UserService] to load 20 users at a time.
  ///
  /// When exceeding the last page, duplicate results of the last possible
  /// page are always returned, therefore filter out duplicates so that we
  /// know when the last page has been received.
  @override
  Future<void> search() async {
    List<User> users = await _userService
        .searchUsers(query: query, page: _page)
        .catchError(twitterClientErrorHandler);

    if (users != null) {
      users = users.where((user) => !_users.contains(user)).toList();
      _log.fine("found ${users.length} users");

      _users.addAll(users);
      _page++;
    }

    // expect to have reached the last page if the length of the result list
    // is not 20
    lastPage = users?.length != 20;
  }

  /// Adds the new query to the search history.
  void _addToSearchHistory() {
    userSearchHistoryModel.addSearchQuery(query);
  }
}
