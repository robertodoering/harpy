import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/config/application_config.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

class AppConfiguration {
  final Logger log = new Logger('AppConfiguration');

  static AppConfiguration _instance = AppConfiguration._();

  factory AppConfiguration() => _instance;

  AppConfiguration._();

  ApplicationConfiguration _applicationConfig;

  TwitterSession _twitterSession;

  init() async {
    log.fine("init was called");
    String appConfigAsString = await rootBundle.loadString('app_config.yaml');
    log.fine("got Config: \n $appConfigAsString");

    var appConfigAsDocument = loadYaml(appConfigAsString);

    _applicationConfig = ApplicationConfiguration(appConfigAsDocument);
  }

  TwitterSession get twitterSession => _twitterSession;

  ApplicationConfiguration get applicationConfig => _applicationConfig;

  set twitterSession(TwitterSession twitterSession) =>
      //TODO persist to shared preferences?
      _twitterSession = twitterSession;
}
