import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';

class LoginStore extends Store {
  static final Action<TwitterLoginResult> twitterLogin = Action();

  Future<bool> get loggedIn => _twitterLogin.isSessionActive;
  Future<TwitterSession> get currentSession => _twitterLogin.currentSession;

  final _twitterLogin = TwitterLogin(
    consumerKey: "todo",
    consumerSecret: "todo",
  );

  TweetService tweetService;

  LoginStore() {
    tweetService = TweetService();

    triggerOnAction(twitterLogin, (_) async {
      final TwitterLoginResult result = await _twitterLogin.authorize();

      tweetService.getTweets(result.session.token).then((response) {
        print(response);
      }).catchError((error) {
        print(error);
      });

      return result;
    });
  }
}

StoreToken loginStoreToken = StoreToken(LoginStore());
