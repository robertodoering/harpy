import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final tweetVisibilityPreferencesProvider = Provider(
  (ref) => TweetVisibilityPreferences(
    preferences: ref.watch(
      preferencesProvider(ref.watch(authPreferencesProvider).userId),
    ),
    generalPreferences: ref.watch(generalPreferencesProvider),
  ),
  name: 'TweetVisibilityPreferencesProvider',
);

class TweetVisibilityPreferences with LoggerMixin {
  TweetVisibilityPreferences({
    required Preferences preferences,
    required GeneralPreferences generalPreferences,
  })  : _preferences = preferences,
        _generalPreferences = generalPreferences;

  final Preferences _preferences;
  final GeneralPreferences _generalPreferences;

  /// The id of the list visible tweet in the home timeline.
  int get lastVisibleTweet => _preferences.getInt('lastVisibleTweet', 0);

  set lastVisibleTweet(int value) =>
      _preferences.setInt('lastVisibleTweet', value);

  /// Updates tweet visibility based on the home timeline position behavior
  /// setting.
  void updateVisibleTweet(LegacyTweetData tweet) {
    if (_generalPreferences.keepLastHomeTimelinePosition) {
      final id = int.tryParse(tweet.originalId);

      if (id != null) {
        final keepNewestReadTweet = _generalPreferences.keepNewestReadTweet;
        final keepLastReadTweet = _generalPreferences.keepLastReadTweet;

        if (keepLastReadTweet ||
            (keepNewestReadTweet && id > lastVisibleTweet)) {
          log.fine('updated last visible tweet to $id');
          lastVisibleTweet = id;
        }
      }
    }
  }

  /// The id of the last viewed mention for the mentions timeline.
  int get lastViewedMention => _preferences.getInt('lastViewedMention', 0);
  set lastViewedMention(int value) =>
      _preferences.setInt('lastViewedMention', value);
}
