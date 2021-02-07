import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/visibility_change_detector.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/preferences/tweet_visibility_preferences.dart';
import 'package:harpy/core/service_locator.dart';

/// Uses the [TweetVisibilityPreferences] to save the newest last visible
/// tweet id.
class TweetRememberVisibility extends StatelessWidget {
  const TweetRememberVisibility({
    @required Key key,
    @required this.tweet,
    @required this.child,
  }) : super(key: key);

  final TweetData tweet;
  final Widget child;

  void _onVisibilityChanged(bool visible) {
    final TweetVisibilityPreferences tweetVisibilityPreferences =
        app<TweetVisibilityPreferences>();

    if (visible) {
      tweetVisibilityPreferences.maybeUpdateVisibleTweet(tweet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityChangeDetector(
      key: key,
      onVisibilityChanged: _onVisibilityChanged,
      child: child,
    );
  }
}
