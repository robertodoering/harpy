import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

class TweetVisibilityPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The id of the list visible tweet in the home timeline.
  int get lastVisibleTweet =>
      harpyPrefs.getInt('lastVisibleTweet', 0, prefix: true);

  set lastVisibleTweet(int value) =>
      harpyPrefs.setInt('lastVisibleTweet', value, prefix: true);

  /// Updates tweet visibility based on the home timeline position behavior
  /// setting.
  void updateVisibleTweet(TweetData tweet) {
    if (app<GeneralPreferences>().keepLastHomeTimelinePosition) {
      final id = int.tryParse(tweet.originalId);

      if (id != null) {
        final keepNewestReadTweet =
            app<GeneralPreferences>().keepNewestReadTweet;
        final keepLastReadTweet = app<GeneralPreferences>().keepLastReadTweet;

        if (keepLastReadTweet ||
            (keepNewestReadTweet && id > lastVisibleTweet)) {
          lastVisibleTweet = id;
        }
      }
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
