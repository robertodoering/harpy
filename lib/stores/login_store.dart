import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/app_configuration.dart';

class LoginStore extends Store {
  static final Action<TwitterLoginResult> twitterLogin = Action();
  static final Action<TwitterSession> setSession = Action();

  final _twitterLogin = TwitterLogin(
    consumerKey: AppConfiguration().applicationConfig.consumerKey,
    consumerSecret: AppConfiguration().applicationConfig.consumerSecret,
  );

  Future<bool> get loggedIn => _twitterLogin.isSessionActive;
  Future<TwitterSession> get currentSession => _twitterLogin.currentSession;

  Future<TwitterLoginResult> get login async {
    await _twitterLogin.authorize();

    TweetService().getHomeTimeline().then((response) {
      print(response.toString());
    }).catchError((error) {
      print(error);
    });
  }

  LoginStore() {
    setSession.listen((session) => AppConfiguration().twitterSession = session);
  }
}

StoreToken loginStoreToken = StoreToken(LoginStore());
