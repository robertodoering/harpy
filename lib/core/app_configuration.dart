import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/config/application_config.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

class AppConfiguration {
  final Logger log = Logger('AppConfiguration');

  static AppConfiguration _instance = AppConfiguration._();

  factory AppConfiguration() => _instance;

  AppConfiguration._();

  TwitterSession twitterSession;
  ApplicationConfiguration applicationConfig;

  TwitterLogin twitterLogin;

  Future<void> init() async {
    // init config
    log.fine("init was called");
    String appConfigAsString = await rootBundle.loadString('app_config.yaml');
    log.fine("got Config: \n$appConfigAsString");

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

  void initForUnitTesting() {
    applicationConfig = ApplicationConfiguration.UnitTesting();
  }
}
