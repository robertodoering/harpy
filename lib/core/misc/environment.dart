import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

const _fallbackAesKey = 'QpIX8Hr8JAKezBYuP4+zTThm1U3fCiIzsPi9057adZM=';

const sentryDns = String.fromEnvironment('sentry_dsn');
const isFree = String.fromEnvironment('flavor', defaultValue: 'free') == 'free';
const isPro = String.fromEnvironment('flavor') == 'pro';

final environmentProvider = Provider(
  (ref) {
    const aesKey = String.fromEnvironment('aes_key');
    const twitterConsumerKey = String.fromEnvironment('twitter_consumer_key');
    const twitterConsumerSecret = String.fromEnvironment(
      'twitter_consumer_secret',
    );

    if (aesKey.isNotEmpty) {
      final encrypter = Encrypter(AES(Key.fromBase64(aesKey)));

      final consumerKeyPair = twitterConsumerKey.split(':');
      final consumerSecretPair = twitterConsumerSecret.split(':');

      final keyIv = IV.fromBase64(consumerKeyPair[0]);
      final encryptedKey = Encrypted.fromBase64(consumerKeyPair[1]);

      final secretIv = IV.fromBase64(consumerSecretPair[0]);
      final encryptedSecret = Encrypted.fromBase64(consumerSecretPair[1]);

      return Environment(
        aesKey: aesKey,
        twitterConsumerKey: encrypter.decrypt(encryptedKey, iv: keyIv),
        twitterConsumerSecret: encrypter.decrypt(encryptedSecret, iv: secretIv),
      );
    } else {
      return const Environment(
        aesKey: _fallbackAesKey,
        twitterConsumerKey: twitterConsumerKey,
        twitterConsumerSecret: twitterConsumerSecret,
      );
    }
  },
  name: 'EnvironmentProvider',
);

class Environment with LoggerMixin {
  const Environment({
    required this.aesKey,
    required this.twitterConsumerKey,
    required this.twitterConsumerSecret,
  });

  final String aesKey;
  final String twitterConsumerKey;
  final String twitterConsumerSecret;

  /// Validates the app configuration from the environment parameters.
  ///
  /// The parameters can be set using the
  /// `--dart-define=key=value`
  /// arguments when running the app.
  ///
  /// Required parameters are:
  /// * twitter_consumer_key (Twitter API key)
  /// * twitter_consumer_secret (Twitter API secret)
  ///
  /// Optional parameters include:
  /// * sentry_dsn (Error reporting service)
  /// * aes_key (Used to decrypt consumer key & secret and encrypted
  ///   preferences)
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
    final valid =
        twitterConsumerKey.isNotEmpty && twitterConsumerSecret.isNotEmpty;

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
