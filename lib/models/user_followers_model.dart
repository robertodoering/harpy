import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/paginated_users.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/paginated_model.dart';
import 'package:harpy/models/user_following_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// The model for showing the followers for a [User].
class UserFollowersModel extends ChangeNotifier
    with PaginatedModel, UserFollowingFollowersModel {
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

  /// Uses the [UserService] to search for the followers of the [User]
  /// corresponding to the [userId].
  @override
  Future<void> search() async {
    final PaginatedUsers paginatedUsers = await userService
        .getFollowers(id: userId, cursor: nextCursor)
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

/// Used by the [UserFollowersModel] and [UserFollowingModel] to hold common
/// logic.
mixin UserFollowingFollowersModel on PaginatedModel {
  /// The list of found users.
  ///
  /// This list will grow as more pages are requested.
  final List<User> users = [];

  /// Whether or not no users have been found.
  bool get noUsersFound => !loading && users.isEmpty;

  /// Determines what page is being returned for the [UserService.getFollowers]
  /// or the [UserService.getFollowing] request.
  ///
  /// `-1` represents the first page.
  @protected
  int nextCursor = -1;
}
