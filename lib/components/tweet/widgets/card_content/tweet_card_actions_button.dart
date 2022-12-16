import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardActionsButton extends StatelessWidget {
  const TweetCardActionsButton({
    required this.tweet,
    required this.delegates,
    required this.padding,
    required this.style,
  });

  final LegacyTweetData tweet;
  final TweetDelegates delegates;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    return MoreActionsButton(
      tweet: tweet,
      sizeDelta: style.sizeDelta,
      onViewMoreActions: (ref) => showTweetActionsBottomSheet(
        ref,
        tweet: tweet,
        delegates: delegates,
      ),
    );
  }
}
