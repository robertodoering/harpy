import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/models/application_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModel extends Model {
  final ApplicationModel applicationModel;

  LoginModel({
    @required this.applicationModel,
  });

  static LoginModel of(BuildContext context) {
    return ScopedModel.of<LoginModel>(context);
  }

  User loggedInUser;

  /// `true` while logging in and initializing on successful login.
  bool authorizing = false;

  bool loggedIn = false;

  Future<void> login() async {
    // todo: logs
    authorizing = true;
    TwitterLoginResult result = await applicationModel.twitterLogin.authorize();
    authorizing = false;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        // logged in successfully
        loggedIn = true;
        applicationModel.twitterSession = result.session;

        // initialize before navigating
        await AsyncInitializer([
          // todo: init home model tweets
          _initLoggedInUser,
        ]).run();
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        // todo: show result.error
        break;
    }

    notifyListeners();
  }

  Future<void> _initLoggedInUser() async {
    String userId = applicationModel.twitterSession.userId;

    loggedInUser =
        UserCache().getCachedUser(userId); // todo user cache in constructor

    if (loggedInUser == null) {
      await _updateLoggedInUser();
    } else {
      _updateLoggedInUser();
    }
  }

  Future<void> _updateLoggedInUser() async {
    String userId = applicationModel.twitterSession.userId;

    loggedInUser = await UserService()
        .getUserDetails(id: userId); // todo user service in constructor
    notifyListeners();
  }
}
