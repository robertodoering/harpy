import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/paginated_users.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/paginated_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// The model for showing the followers for a [User].
class UserFollowersModel extends ChangeNotifier with PaginatedModel {
  UserFollowersModel({
    @required this.userId,
  }) {
    initialize();
  }

  final UserService userService = app<UserService>();

  /// The id of the [User] for whom to search for.
  final String userId;

  static UserFollowersModel of(BuildContext context) {
    return Provider.of<UserFollowersModel>(context);
  }

  static final Logger _log = Logger("UserFollowersModel");

  /// The list of found followers.
  ///
  /// This list will grow as more pages are requested.
  final List<User> _users = [];
  List<User> get users => UnmodifiableListView(_users);

  /// Determines what page is being returned for the [UserService.getFollowers]
  /// request.
  ///
  /// `-1` represents the first page.
  int _nextCursor = -1;

  /// Uses the [UserService] to search for the followers of the [User]
  /// corresponding to the [userId].
  @override
  Future<void> search() async {
    final PaginatedUsers paginatedUsers = await userService
        .getFollowers(id: userId, cursor: _nextCursor)
        .catchError(twitterClientErrorHandler);

    if (paginatedUsers != null) {
      _log.fine("found ${paginatedUsers.users.length} users");

      _users.addAll(paginatedUsers.users);
      _nextCursor = paginatedUsers.nextCursor;
    }

    lastPage = paginatedUsers?.lastPage ?? true;
  }
}
