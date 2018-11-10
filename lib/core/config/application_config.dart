import 'package:harpy/core/config/cache_configuration.dart';

class ApplicationConfiguration {
  String _consumerKey;
  String _consumerSecret;

  CacheConfiguration cacheConfiguration;

  ApplicationConfiguration(yamlDoc) {
    _consumerKey = yamlDoc["twitter"]["consumerKey"];
    _consumerSecret = yamlDoc["twitter"]["consumerSecret"];

    cacheConfiguration = CacheConfiguration(yamlDoc["cache"]);
  }
  ApplicationConfiguration.UnitTesting() {
    cacheConfiguration = CacheConfiguration.UnitTesting();
  }

  String get consumerKey => _consumerKey;

  String get consumerSecret => _consumerSecret;

  set consumerSecret(String value) => _consumerSecret = value;

  set consumerKey(String value) => _consumerKey = value;
}
