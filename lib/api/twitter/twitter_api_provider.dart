import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/misc/environment.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

final twitterApiV1Provider = Provider(
  name: 'twitterApiV1Provider',
  (ref) {
    final authPreferences = ref.watch(authPreferencesProvider);
    final key = ref.watch(consumerKeyProvider);
    final secret = ref.watch(consumerSecretProvider);

    return TwitterApi(
      client: TwitterClient(
        consumerKey: key,
        consumerSecret: secret,
        token: authPreferences.userToken,
        secret: authPreferences.userSecret,
      ),
    );
  },
);

final twitterApiV2Provider = Provider(
  name: 'twitterApiV2Provider',
  (ref) {
    final authPreferences = ref.watch(authPreferencesProvider);
    final key = ref.watch(consumerKeyProvider);
    final secret = ref.watch(consumerSecretProvider);

    return v2.TwitterApi(
      bearerToken: '',
      oauthTokens: v2.OAuthTokens(
        consumerKey: key,
        consumerSecret: secret,
        accessToken: authPreferences.userToken,
        accessTokenSecret: authPreferences.userSecret,
      ),
    );
  },
);

final consumerKeyProvider = Provider(
  name: 'consumerKeyProvider',
  (ref) {
    final environment = ref.watch(environmentProvider);
    final customApiPreferences = ref.watch(customApiPreferencesProvider);

    return customApiPreferences.hasCustomApiKeyAndSecret
        ? customApiPreferences.customKey
        : environment.twitterConsumerKey;
  },
);

final consumerSecretProvider = Provider(
  name: 'consumerSecretProvider',
  (ref) {
    final environment = ref.watch(environmentProvider);
    final customApiPreferences = ref.watch(customApiPreferencesProvider);

    return customApiPreferences.hasCustomApiKeyAndSecret
        ? customApiPreferences.customSecret
        : environment.twitterConsumerSecret;
  },
);
