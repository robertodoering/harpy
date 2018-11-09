import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/app_configuration.dart';

class LoginStore extends Store {
  static final Action<TwitterLoginResult> twitterLogin = Action();
  static final Action<TwitterSession> setSession = Action();

  bool get loggedIn => AppConfiguration().twitterSession != null;

  Future<TwitterLoginResult> get login async =>
      await AppConfiguration().twitterLogin.authorize();

  LoginStore() {
    setSession.listen((session) => AppConfiguration().twitterSession = session);
  }
}
