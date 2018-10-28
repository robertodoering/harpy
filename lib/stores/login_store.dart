import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class LoginStore extends Store {
  static final Action<TwitterLoginResult> twitterLogin = Action();

  Future<bool> get loggedIn => _twitterLogin.isSessionActive;

  final _twitterLogin =
      TwitterLogin(consumerKey: "todo", consumerSecret: "todo");

  LoginStore() {
    triggerOnAction(twitterLogin, (_) async {
      final TwitterLoginResult result = await _twitterLogin.authorize();
      print(result.status);
      return result;
    });
  }
}

StoreToken loginStoreToken = StoreToken(LoginStore());
