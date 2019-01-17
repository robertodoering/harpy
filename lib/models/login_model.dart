import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/models/application_model.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModel extends Model {
  LoginModel({
    @required this.applicationModel,
    @required this.userCache,
  })  : assert(applicationModel != null),
        assert(userCache != null);

  final ApplicationModel applicationModel;
  final UserCache userCache;

  static LoginModel of(BuildContext context) {
    return ScopedModel.of<LoginModel>(context);
  }

  static final Logger _log = Logger("LoginModel");

  /// Holds a the information for the currently logged in [User].
  ///
  /// If [loggedIn] is `false` this is `null`.
  User loggedInUser;

  /// `true` while logging in and initializing on successful login.
  bool authorizing = false;

  /// A callback that is called when the authorization completed.
  VoidCallback onAuthorized;

  Future<void> login() async {
    _log.fine("logging in");

    authorizing = true;
    notifyListeners();
    TwitterLoginResult result = await applicationModel.twitterLogin.authorize();
    authorizing = false;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        _log.fine("successfully logged in");
        applicationModel.twitterSession = result.session;

        // initialize before navigating
        await AsyncInitializer([
          // todo: init home model tweets
          _initLoggedInUser,
        ]).run();

        if (onAuthorized != null) {
          onAuthorized();
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        _log.info("login cancelled by user");
        break;
      case TwitterLoginStatus.error:
        _log.warning("error during login");
        // todo: show result.error
        break;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _log.fine("logging out");

    await applicationModel.twitterLogin.logOut();

    applicationModel.twitterSession = null;
    loggedInUser = null;
  }

  Future<void> _initLoggedInUser() async {
    _log.fine("initializing logged in user");

    String userId = applicationModel.twitterSession.userId;

    loggedInUser = userCache.getCachedUser(userId);

    if (loggedInUser == null) {
      _log.fine("user not in cache, waiting to update logged in user");
      await _updateLoggedInUser();
    } else {
      _log.fine("user in cache, immediately returning and updating user");
      _updateLoggedInUser();
    }
  }

  Future<void> _updateLoggedInUser() async {
    _log.fine("updating logged in user");

    String userId = applicationModel.twitterSession.userId;

    loggedInUser = await UserService()
        .getUserDetails(id: userId); // todo user service in constructor
    notifyListeners();
  }
}
