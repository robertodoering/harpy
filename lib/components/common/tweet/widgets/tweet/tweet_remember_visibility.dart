import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Uses the [TweetVisibilityPreferences] to save the last visible tweet id.
class TweetRememberVisibility extends StatelessWidget {
  const TweetRememberVisibility({
    required Key key,
    required this.tweet,
    required this.child,
  }) : super(key: key);

  final TweetData? tweet;
  final Widget child;

  void _onVisibilityChanged(bool visible) {
    final TweetVisibilityPreferences? tweetVisibilityPreferences =
        app<TweetVisibilityPreferences>();

    if (visible) {
      tweetVisibilityPreferences!.updateVisibleTweet(tweet!);
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
