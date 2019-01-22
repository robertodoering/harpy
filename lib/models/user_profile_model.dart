import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class UserProfileModel extends Model {
  UserProfileModel({
    this.user,
    String userId,
    @required this.userService,
    @required this.userCache,
  })  : assert(userService != null),
        assert(userCache != null),
        assert(user != null || userId != null) {
    if (user != null) {
      loadingUser = false;
    } else {
      _loadUser(userId);
    }
  }

  final UserService userService;
  final UserCache userCache;

  static final Logger _log = Logger("UserProfileModel");

  static UserProfileModel of(BuildContext context) {
    return ScopedModel.of<UserProfileModel>(context);
  }

  /// The [user] for this [UserProfileModel].
  User user;

  /// `true` while loading the user.
  bool loadingUser = true;

  /// `true` if the user was unable to be loaded.
  bool get loadingError => user == null && loadingUser == false;

  /// Loads the [user] from cache and updates it asynchronously or waits for the
  /// api if the [user] hasn't been cached before.
  Future<void> _loadUser(String id) async {
    _log.fine("loading user");

    User cachedUser = userCache.getCachedUser(id);

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

    User loadedUser = await userService.getUserDetails(id: id).catchError((_) {
      _log.warning("unable to update user");
      return null;
    });

    if (loadedUser != null) {
      _log.fine("updated user");

      user = loadedUser;
      loadingUser = false;
      notifyListeners();
      return true;
    }

    return false;
  }
}
