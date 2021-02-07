import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/logger_mixin.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class TweetVisibilityPreferences with Logger {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  int get lastVisibleTweet => harpyPrefs.getInt('lastVisibleTweet', 0);
  set lastVisibleTweet(int value) =>
      harpyPrefs.setInt('lastVisibleTweet', value);

  void updateVisibleTweet(TweetData tweet) {
    final int id = int.tryParse(tweet.idStr);

    if (id != null) {
      lastVisibleTweet = id;
    }
  }
}
