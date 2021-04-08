import 'package:logging/logging.dart';

final Logger _log = Logger('AppConfig');

const String twitterConsumerKey =
    String.fromEnvironment('twitter_consumer_key');

const String twitterConsumerSecret =
    String.fromEnvironment('twitter_consumer_secret');

const String sentryDsn = String.fromEnvironment('sentry_dsn');
const bool hasSentryDsn = bool.hasEnvironment('sentry_dsn');

final bool hasTwitterConfig =
    (twitterConsumerKey != null && twitterConsumerKey.isNotEmpty) &&
        (twitterConsumerSecret != null && twitterConsumerSecret.isNotEmpty);

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
void validateAppConfig() {
  if (!hasTwitterConfig) {
    _log.severe(
      'Twitter api key or secret is missing.\n'
      'Make sure to add the twitter_consumer_key and\n'
      'twitter_consumer_secret environment parameters when building '
      'the app.\n\n'
      'For example:\n'
      'flutter run \\\n'
      '--flavor free \\\n'
      '--dart-define=flavor=free \\\n'
      '--dart-define=twitter_consumer_key=your_consumer_key \\\n'
      '--dart-define=twitter_consumer_secret=your_consumer_secret',
    );
  }
}
