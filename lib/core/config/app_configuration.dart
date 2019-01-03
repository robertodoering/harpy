import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

class AppConfiguration {
  final Logger log = Logger("AppConfiguration");

  static AppConfiguration _instance = AppConfiguration._();
  factory AppConfiguration() => _instance;
  AppConfiguration._();

  /// The twitter api key and secret.
  String consumerKey;
  String consumerSecret;

  /// The [twitterSession] contains information about the logged in user.
  ///
  /// If the user is not logged in [twitterSession] will be null.
  TwitterSession twitterSession;

  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  Future<void> init() async {
    // init config
    log.fine("init app configuration");
    String appConfig = await rootBundle.loadString('app_config.yaml');
    log.fine("got config");

    YamlMap yamlMap = loadYaml(appConfig);
    consumerKey = yamlMap["twitter"]["consumerKey"];
    consumerSecret = yamlMap["twitter"]["consumerSecret"];

    // init twitter login
    twitterLogin = TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    // init active twitter session
    twitterSession = await twitterLogin.currentSession;
  }
}
