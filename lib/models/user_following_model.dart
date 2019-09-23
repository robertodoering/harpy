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

/// The model for showing the following users for a [User].
class UserFollowingModel extends ChangeNotifier with PaginatedModel {
  UserFollowingModel({
    @required this.userId,
  }) {
    initialize();
  }

  final UserService _userService = app<UserService>();

  /// The id of the [User] for whom to search for.
  final String userId;

  static UserFollowingModel of(BuildContext context) {
    return Provider.of<UserFollowingModel>(context);
  }

  static final Logger _log = Logger("UserFollowersModel");

  /// The list of found followers.
  ///
  /// This list will grow as more pages are requested.
  final List<User> _users = [];
  List<User> get users => UnmodifiableListView(_users);

  /// Determines what page is being returned for the [UserService.getFollowing]
  /// request.
  ///
  /// `-1` represents the first page.
  int _nextCursor = -1;

  @override
  Future<void> search() async {
    final PaginatedUsers paginatedUsers = await _userService
        .getFollowing(id: userId, cursor: _nextCursor)
        .catchError(twitterClientErrorHandler);

    if (paginatedUsers != null) {
      _log.fine("found ${paginatedUsers.users.length} users");

      _users.addAll(paginatedUsers.users);
      _nextCursor = paginatedUsers.nextCursor;
    }

    lastPage = paginatedUsers?.lastPage ?? true;
  }
}
