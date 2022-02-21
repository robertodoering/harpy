import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

class RetweetButton extends ConsumerWidget {
  const RetweetButton({
    required this.tweet,
    required this.onRetweet,
    required this.onUnretweet,
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final TweetActionCallback? onRetweet;
  final TweetActionCallback? onUnretweet;
  final double sizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: tweet.retweeted,
      value: tweet.retweetCount,
      iconBuilder: (_) => Icon(FeatherIcons.repeat, size: iconSize - 1),
      iconAnimationBuilder: (animation, child) => RotationTransition(
        turns: CurvedAnimation(curve: Curves.easeOutBack, parent: animation),
        child: child,
      ),
      bubblesColor: BubblesColor(
        primary: Colors.lime,
        secondary: Colors.limeAccent,
        tertiary: Colors.green,
        quaternary: Colors.green[900],
      ),
      circleColor: const CircleColor(start: Colors.green, end: Colors.lime),
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activeColor: harpyTheme.colors.retweet,
      activate: () => onRetweet?.call(context, ref.read),
      deactivate: () => onUnretweet?.call(context, ref.read),
    );
  }
}
