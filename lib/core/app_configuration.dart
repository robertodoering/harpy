import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/config/application_config.dart';
import 'package:yaml/yaml.dart';

class AppConfiguration {
  static AppConfiguration _instance = AppConfiguration._();

  factory AppConfiguration() => _instance;

  AppConfiguration._();

  // todo: persist to shared preferences?
  TwitterSession twitterSession;
  ApplicationConfiguration applicationConfig;

  TwitterLogin twitterLogin;

  Future<void> init() async {
    // init config
    String appConfigAsString = await rootBundle.loadString('app_config.yaml');
    var appConfigAsDocument = loadYaml(appConfigAsString);
    applicationConfig = ApplicationConfiguration(appConfigAsDocument);

    // init twitter login
    twitterLogin = TwitterLogin(
      consumerKey: applicationConfig.consumerKey,
      consumerSecret: applicationConfig.consumerSecret,
    );

    // init active twitter session
    twitterSession = await twitterLogin.currentSession;
  }
}
