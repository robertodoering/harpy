import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardActionsButton extends ConsumerWidget {
  const TweetCardActionsButton({
    required this.tweet,
    required this.onViewActions,
    required this.padding,
    required this.style,
  });

  final TweetData tweet;
  final TweetActionCallback? onViewActions;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    return HarpyButton.icon(
      icon: Icon(
        CupertinoIcons.ellipsis_vertical,
        size: iconTheme.size! + style.sizeDelta,
      ),
      padding: padding,
      onTap: () => onViewActions?.call(context, ref.read),
    );
  }
}
