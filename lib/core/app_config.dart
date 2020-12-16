import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Provides the [AppConfigData] that is set through environment parameters
/// when the app is built.
class AppConfig {
  static final Logger _log = Logger('AppConfig');

  AppConfigData data;

  /// Initializes the [data] from the environment parameters.
  ///
  /// If the configuration is invalid, [data] will be `null`.
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
  void initialize() {
    _log.fine('initializing app config');

    const AppConfigData appConfigData = AppConfigData(
      twitterConsumerKey: String.fromEnvironment('twitter_consumer_key'),
      twitterConsumerSecret: String.fromEnvironment('twitter_consumer_secret'),
      sentryDsn: String.fromEnvironment('sentry_dsn'),
    );

    if (appConfigData.invalidTwitterConfig) {
      _log.severe('Twitter api key or secret is missing.\n'
          'Make sure to add the twitter_consumer_key and\n'
          'twitter_consumer_secret environment parameters when building '
          'the app.\n\n'
          'For example:\n'
          'flutter run \\\n'
          '--flavor free \\\n'
          '--dart-define=flavor=free \\\n'
          '--dart-define=twitter_consumer_key=your_consumer_key \\\n'
          '--dart-define=twitter_consumer_secret=your_consumer_secret');
    } else {
      data = appConfigData;
    }
  }
}

@immutable
class AppConfigData {
  const AppConfigData({
    @required this.twitterConsumerKey,
    @required this.twitterConsumerSecret,
    @required this.sentryDsn,
  });

  final String twitterConsumerKey;
  final String twitterConsumerSecret;

  final String sentryDsn;

  bool get invalidTwitterConfig =>
      (twitterConsumerKey == null || twitterConsumerKey.isEmpty) &&
      (twitterConsumerSecret == null || twitterConsumerSecret.isEmpty);
}
