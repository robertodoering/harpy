import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/login_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class UserProfileModel extends ChangeNotifier {
  UserProfileModel({
    @required this.loginModel,
    this.user,
    String userId,
  })  : assert(loginModel != null),
        assert(user != null || userId != null) {
    if (user != null) {
      loadingUser = false;
    } else {
      _loadUser(userId);
    }
  }

  final UserService userService = app<UserService>();

  final LoginModel loginModel;

  static UserProfileModel of(BuildContext context) {
    return Provider.of<UserProfileModel>(context);
  }

  static final Logger _log = Logger("UserProfileModel");

  /// The [user] for this [UserProfileModel].
  User user;

  /// `true` while loading the user.
  bool loadingUser = true;

  /// `true` if the user was unable to be loaded.
  bool get loadingError => user == null && loadingUser == false;

  /// `true` if [user] is the logged in user (When the user is looking at his
  /// own profile).
  bool get isLoggedInUser => user.id == loginModel.loggedInUser.id;

  /// Loads the [user] from cache and updates it asynchronously or waits for the
  /// api if the [user] hasn't been cached before.
  Future<void> _loadUser(String id) async {
    _log.fine("loading user");

    final User cachedUser = null; // todo: get from cache

    if (cachedUser != null) {
      _log.fine("found cached user");

      user = cachedUser;
      loadingUser = false;
      notifyListeners();
      _updateUser(id);
    } else {
      _log.fine("user not in cache, waiting to update user");

      if (!await _updateUser(id)) {
        // user was unable to update
        loadingUser = false;
        notifyListeners();
      }
    }
  }

  /// Updates the user and returns `true` if it was successfully updated.
  Future<bool> _updateUser(String id) async {
    _log.fine("updating user");

    final User loadedUser = await userService.getUserDetails(id: id).catchError(
      (error) {
        _log.warning("unable to update user with id $id");

        twitterClientErrorHandler(
          error,
          "An unexpected error occurred while trying to update logged in user",
        );
      },
    );

    if (loadedUser != null) {
      user = loadedUser;
      loadingUser = false;
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Follows or unfollows the [User].
  Future<void> changeFollowState() async {
    _log.fine("changing follower state");

    if (user.following) {
      _log.fine("unfollowing user");

      user.following = false;
      notifyListeners();
      userService.destroyFriendship("${user.id}").catchError((error) {
        _log.warning("unable to unfollow user");

        twitterClientErrorHandler(
          error,
          "An unexpected error occurred while trying to unfollow the user",
        );

        user.following = true;
        notifyListeners();
      });
    } else {
      _log.fine("following user");

      user.following = true;
      notifyListeners();
      userService.createFriendship("${user.id}").catchError((error) {
        _log.warning("unable to follow user");

        twitterClientErrorHandler(
          error,
          "An unexpected error occurred while trying to follow the user",
        );

        user.following = false;
        notifyListeners();
      });
    }
  }
}
