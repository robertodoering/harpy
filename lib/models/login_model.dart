import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/error_handler.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/initialization_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/misc/flushbar.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class LoginModel extends ChangeNotifier {
  LoginModel({
    @required this.homeTimelineModel,
    @required this.userService,
    @required this.userCache,
  })  : assert(homeTimelineModel != null),
        assert(userService != null),
        assert(userCache != null);

  final HomeTimelineModel homeTimelineModel;
  final UserService userService;
  final UserCache userCache;

  ApplicationModel applicationModel;

  static LoginModel of(BuildContext context) {
    return Provider.of<LoginModel>(context);
  }

  static final Logger _log = Logger("LoginModel");

  /// Holds a the information for the currently logged in [User].
  ///
  /// If [applicationModel.loggedIn] is `false` this is `null`.
  User loggedInUser;

  /// `true` while logging in and initializing on successful login.
  bool authorizing = false;

  /// Login using the native twitter sdk.
  Future<void> login() async {
    _log.fine("logging in");

    authorizing = true;
    notifyListeners();
    TwitterLoginResult result = await applicationModel.twitterLogin.authorize();
    authorizing = false;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        _log.fine("successfully logged in");
        _onSuccessfulLogin(result);
        break;
      case TwitterLoginStatus.cancelledByUser:
        _log.info("login cancelled by user");
        HarpyNavigator.pushReplacement(LoginScreen());
        break;
      case TwitterLoginStatus.error:
        _log.warning("error during login");
        _onLoginError();
        break;
    }

    notifyListeners();
  }

  Future<void> _onSuccessfulLogin(TwitterLoginResult result) async {
    applicationModel.twitterSession = result.session;

    // init tweet cache logged in user
    applicationModel.initLoggedIn();

    // initialize before navigating
    bool knownUser = await initBeforeHome();
    knownUser = false; // todo: remove

    // makes sure we were able to get the logged in user before navigating
    if (applicationModel.loggedIn && loggedInUser != null) {
      if (knownUser) {
        _log.fine("navigating to home screen after login");
        HarpyNavigator.pushReplacementRoute(FadeRoute(
          builder: (context) => HomeScreen(),
        ));
      } else {
        _log.fine("navigating to initialization screen after login");
        // user logged in for the first time
        HarpyNavigator.pushReplacementRoute(FadeRoute(
          builder: (context) => InitializationScreen(),
        ));
      }
    } else {
      _log.severe("unable to retreive logged in user after successful "
          "authorization");
      _onLoginError();
    }
  }

  void _onLoginError() {
    HarpyNavigator.pushReplacement(LoginScreen());
    showFlushbar("An error occurred during login.", type: FlushbarType.error);
  }

  /// Logout using the native twitter sdk.
  Future<void> logout() async {
    _log.fine("logging out");

    await applicationModel.twitterLogin.logOut();

    applicationModel.twitterSession = null;
    loggedInUser = null;
  }

  /// Initializes the logged in user and the home timeline tweets.
  ///
  /// Returns `true` if the logged in user has been logged in before, `false`
  /// otherwise.
  Future<bool> initBeforeHome() async {
    List<dynamic> results = await Future.wait<dynamic>([
      homeTimelineModel.initTweets(),
      _initLoggedInUser(),
    ]);

    print("got results: $results");

    if (results.last is bool) {
      print("last is bool, returning ${results.last}");
      return results.last;
    }

    return true;
  }

  /// Gets the logged in user from cache and then updates it without waiting
  /// or waits to retrieve the user details when they are not cached.
  ///
  /// Returns `true` if the user has been cached (and therefore logged in
  /// before).
  /// Returns `false` if the user logged in for the first time.
  Future<bool> _initLoggedInUser() async {
    _log.fine("initializing logged in user");

    String userId = applicationModel.twitterSession.userId;

    // init theme from shared prefs
    applicationModel.themeSettingsModel.initTheme();

    loggedInUser = userCache.getCachedUser(userId);

    if (loggedInUser == null) {
      _log.fine("user not in cache, waiting to update logged in user");
      await _updateLoggedInUser();
      return false;
    } else {
      _log.fine("user in cache, immediately returning and updating user");
      _updateLoggedInUser();
      return true;
    }
  }

  /// Retrieves user details for the logged in user.
  Future<void> _updateLoggedInUser() async {
    _log.fine("updating logged in user");

    String userId = applicationModel.twitterSession.userId;

    User user = await userService.getUserDetails(id: userId).catchError(
      (error) {
        _log.warning("unable to update logged in user");

        twitterClientErrorHandler(
          error,
          "An unexpected error occurred while trying to update the logged in "
          "user",
        );
      },
    );

    if (user != null) {
      loggedInUser = user;
    }

    notifyListeners();
  }
}
