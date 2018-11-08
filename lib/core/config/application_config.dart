//TODO Load from .yaml file
class ApplicationConfiguration {
  String _consumerKey;
  String _consumerSecret;

  ApplicationConfiguration(yamlDoc) {
    _consumerKey = yamlDoc["twitter"]["consumerKey"];
    _consumerSecret = yamlDoc["twitter"]["consumerSecret"];
  }

  String get consumerKey => _consumerKey;

  String get consumerSecret => _consumerSecret;

  set consumerSecret(String value) => _consumerSecret = value;

  set consumerKey(String value) => _consumerKey = value;
}
