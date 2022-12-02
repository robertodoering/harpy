import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class Repliesbutton extends ConsumerWidget {
  const Repliesbutton({
    required this.tweet,
    required this.onShowReplies,
    this.sizeDelta = 0,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onShowReplies;
  final double sizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => Icon(CupertinoIcons.bubble_left, size: iconSize),
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activate: () => onShowReplies?.call(ref),
      deactivate: null,
    );
  }
}
