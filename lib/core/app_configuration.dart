import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/config/application_config.dart';

class AppConfiguration {
  static AppConfiguration _instance = AppConfiguration._();

  factory AppConfiguration() => _instance;

  AppConfiguration._();

  ApplicationConfiguration applicationConfig = ApplicationConfiguration();

  TwitterSession _twitterSession;

  TwitterSession get twitterSession => _twitterSession;

  set twitterSession(TwitterSession twitterSession) =>
      //TODO persist to shared preferences?
      _twitterSession = twitterSession;
}
