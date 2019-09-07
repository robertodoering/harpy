import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/user_search_history_model.dart';
import 'package:logging/logging.dart';

class UserSearchModel extends ChangeNotifier {
  UserSearchModel({
    @required this.query,
    @required this.userSearchHistoryModel,
  }) {
    _initUsers();
    _addToSearchHistory();
  }

  final UserService userService = app<UserService>();

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
  bool get noUsersFound => !_loading && _users.isEmpty;

  /// `true` while the users are loaded initially.
  bool _loading = true;
  bool get loading => _loading;

  int _page = 1;

  /// Whether or not all users that match the [query] have been searched for.
  bool _lastPage = false;
  bool get lastPage => _lastPage;

  /// Loads the initial list of users.
  Future<void> _initUsers() async {
    await _searchUsers();

    _loading = false;
    notifyListeners();
  }

  /// Uses the [UserService] to load 20 users at a time.
  ///
  /// When exceeding the last page, duplicate results of the last possible
  /// page are always returned, therefore filter out duplicates so that we
  /// know when the last page has been received.
  Future<void> _searchUsers() async {
    List<User> users = await userService
        .searchUsers(query: query, page: _page)
        .catchError(twitterClientErrorHandler);

    if (users != null) {
      users = users.where((user) => !_users.contains(user)).toList();
      _log.fine("found ${users.length} users");

      _users.addAll(users);
    }

    // expect to have reached the last page if the length of the result ist
    // not 20
    _lastPage = users?.length != 20;
  }

  /// Loads 20 more users.
  ///
  /// Does nothing when [lastPage] is `true`.
  Future<void> loadMore() async {
    if (lastPage) {
      _log.warning("tried to load more users when already on the last page");
      return;
    }

    _page++;
    await _searchUsers();
    notifyListeners();
  }

  /// Adds the new query to the search history.
  void _addToSearchHistory() {
    userSearchHistoryModel.addSearchQuery(query);
  }
}
