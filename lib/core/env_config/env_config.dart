import 'package:flutter/widgets.dart';
import 'package:harpy/core/core.dart';

/// Wrapper for environment variables that are set with --dart-define when
/// running the app.
class EnvConfig with HarpyLogger {
  const EnvConfig();

  @visibleForTesting
  String get twitterConsumerKey =>
      const String.fromEnvironment('twitter_consumer_key');

  @visibleForTesting
  String get twitterConsumerSecret =>
      const String.fromEnvironment('twitter_consumer_secret');

  String get sentryDsn => const String.fromEnvironment('sentry_dsn');

  bool get hasSentryDsn => const bool.hasEnvironment('sentry_dsn');

  List<String> get _keys => twitterConsumerKey
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  List<String> get _secrets => twitterConsumerSecret
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  int get credentialsCount {
    assert(_keys.length == _secrets.length);

    return _keys.length;
  }

  String key(int auth) {
    if (auth >= 0 && auth < _keys.length) {
      return _keys[auth];
    } else {
      return _keys[0];
    }
  }

  String secret(int auth) {
    if (auth >= 0 && auth < _secrets.length) {
      return _secrets[auth];
    } else {
      return _secrets[0];
    }
  }

  /// Validates the app configuration from the environment parameters.
  ///
  /// The parameters can be set using the
  /// `--dart-define=key=value`
  /// flags when running the app.
  ///
  /// Required parameters include:
  /// * twitter_consumer_key (Twitter API key)
  /// * twitter_consumer_secret (Twitter API secret)
  ///
  /// Optional parameters include:
  /// * sentry_dsn (Error reporting service)
  ///
  /// For example:
  /// ```
  /// flutter run \
  /// --flavor free \
  /// --dart-define=flavor=free \
  /// --dart-define=twitter_consumer_key=your_consumer_key \
  /// --dart-define=twitter_consumer_secret=your_consumer_secret
  /// ```
  bool validateAppConfig() {
    final valid = _keys.isNotEmpty && _secrets.isNotEmpty;

    if (!valid) {
      log.severe(
        'Twitter api key or secret is missing.\n'
        'Make sure to add the twitter_consumer_key and\n'
        'twitter_consumer_secret environment parameters when building '
        'the app.\n\n'
        'For example:\n'
        'flutter run \\\n'
        '--flavor free \\\n'
        '--dart-define=flavor=free \\\n'
        '--dart-define=twitter_consumer_key=your_consumer_key \\\n'
        '--dart-define=twitter_consumer_secret=your_consumer_secret\n\n'
        'For more information, see\n'
        'https://github.com/robertodoering/harpy/wiki/Troubleshooting',
      );
    }

    return valid;
  }
}
