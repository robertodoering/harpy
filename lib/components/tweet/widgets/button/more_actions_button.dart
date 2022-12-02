import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class MoreActionsButton extends ConsumerWidget {
  const MoreActionsButton({
    required this.tweet,
    required this.onViewMoreActions,
    this.sizeDelta = 0,
    this.foregroundColor,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onViewMoreActions;
  final double sizeDelta;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => Icon(
        CupertinoIcons.ellipsis_vertical,
        size: iconSize,
      ),
      foregroundColor: foregroundColor,
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activate: () => onViewMoreActions?.call(ref),
      deactivate: null,
    );
  }
}
