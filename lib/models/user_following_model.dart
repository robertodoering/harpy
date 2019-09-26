import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/paginated_users.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/paginated_model.dart';
import 'package:harpy/models/user_followers_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// The model for showing the following users for a [User].
class UserFollowingModel extends ChangeNotifier
    with PaginatedModel, UserFollowingFollowersModel {
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

  @override
  Future<void> search() async {
    final PaginatedUsers paginatedUsers = await _userService
        .getFollowing(id: userId, cursor: nextCursor)
        .catchError(twitterClientErrorHandler);

    if (paginatedUsers != null) {
      _log.fine("found ${paginatedUsers.users.length} users");

      users.addAll(paginatedUsers.users);
      nextCursor = paginatedUsers.nextCursor;

      lastPage = paginatedUsers.lastPage || paginatedUsers.users.isEmpty;
    } else {
      lastPage = true;
    }
  }
}
