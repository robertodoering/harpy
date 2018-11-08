import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/config/application_config.dart';
import 'package:yaml/yaml.dart';

class AppConfiguration {
  static AppConfiguration _instance = AppConfiguration._();

  factory AppConfiguration() => _instance;

  AppConfiguration._();

  ApplicationConfiguration _applicationConfig;

  TwitterSession _twitterSession;

  init() async {
    String appConfigAsString = await rootBundle.loadString('app_config.yaml');
    var appConfigAsDocument = loadYaml(appConfigAsString);

    _applicationConfig = ApplicationConfiguration(appConfigAsDocument);
  }

  TwitterSession get twitterSession => _twitterSession;

  ApplicationConfiguration get applicationConfig => _applicationConfig;

  set twitterSession(TwitterSession twitterSession) =>
      //TODO persist to shared preferences?
      _twitterSession = twitterSession;
}
