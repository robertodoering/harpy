import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Uses the [TweetVisibilityPreferences] to save the last visible tweet id.
///
/// A [VisibilityChangeDetector] is required to be built above this widget.
class TweetRememberVisibility extends StatefulWidget {
  const TweetRememberVisibility({
    required Key key,
    required this.tweet,
    required this.child,
  }) : super(key: key);

  final TweetData tweet;
  final Widget child;

  @override
  _TweetRememberVisibilityState createState() =>
      _TweetRememberVisibilityState();
}

class _TweetRememberVisibilityState extends State<TweetRememberVisibility> {
  late VisibilityChange _visibilityChange;

  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _visibilityChange = VisibilityChange.of(context)!
      ..addOnVisibilityChanged(
        _onVisibilityChanged,
      );
  }

  @override
  void dispose() {
    super.dispose();

    _visibilityChange.removeOnVisibilityChanged(
      _onVisibilityChanged,
    );
  }

  void _onVisibilityChanged(bool visible) {
    final tweetVisibilityPreferences = app<TweetVisibilityPreferences>();

    _visible = visible;

    if (_visible) {
      // wait a second to see whether this tweet is still visible before
      // updating the visibility
      Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        if (mounted && _visible) {
          tweetVisibilityPreferences.updateVisibleTweet(widget.tweet);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
