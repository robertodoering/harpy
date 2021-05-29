import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

class TweetVisibilityPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The id of the list visible tweet in the home timeline.
  int get lastVisibleTweet =>
      harpyPrefs.getInt('lastVisibleTweet', 0, prefix: true);
  set lastVisibleTweet(int value) =>
      harpyPrefs.setInt('lastVisibleTweet', value, prefix: true);

  void updateVisibleTweet(TweetData tweet) {
    final id = int.tryParse(tweet.originalId);

    if (id != null && id > lastVisibleTweet) {
      lastVisibleTweet = id;
    }
  }

  /// The id of the last viewed mention for the mentions timeline.
  int get lastViewedMention =>
      harpyPrefs.getInt('lastViewedMention', 0, prefix: true);
  set lastViewedMention(int value) =>
      harpyPrefs.setInt('lastViewedMention', value, prefix: true);

  void updateLastViewedMention(TweetData tweet) {
    final id = int.tryParse(tweet.originalId);

    if (id != null) {
      lastViewedMention = id;
    }
  }
}
