import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/app_configuration.dart';

class LoginStore extends Store {
  static final Action<TwitterLoginResult> twitterLogin = Action();

  Future<bool> get loggedIn => _twitterLogin.isSessionActive;
  Future<TwitterSession> get currentSession => _twitterLogin.currentSession;

  final _twitterLogin = TwitterLogin(
    consumerKey: AppConfiguration().applicationConfig.consumerKey,
    consumerSecret: AppConfiguration().applicationConfig.consumerSecret,
  );

  LoginStore() {
    triggerOnAction(twitterLogin, (_) async {
      final TwitterLoginResult result = await _twitterLogin.authorize();

      print("Login: " + result.status.toString());

      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          AppConfiguration().twitterSession = result.session;

          TweetService().getHomeTimeline().then((response) {
            print(response.toString());
          }).catchError((error) {
            print(error);
          });

          break;
        case TwitterLoginStatus.cancelledByUser:
          break;
        case TwitterLoginStatus.error:
          break;
      }
    });
  }
}

StoreToken loginStoreToken = StoreToken(LoginStore());
