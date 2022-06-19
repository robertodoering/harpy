import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/misc/environment.dart';

final twitterApiProvider = Provider(
  (ref) {
    final environment = ref.watch(environmentProvider);
    final authPreferences = ref.watch(authPreferencesProvider);

    return TwitterApi(
      client: TwitterClient(
        consumerKey: environment.twitterConsumerKey,
        consumerSecret: environment.twitterConsumerSecret,
        token: authPreferences.userToken,
        secret: authPreferences.userSecret,
      ),
    );
  },
);
