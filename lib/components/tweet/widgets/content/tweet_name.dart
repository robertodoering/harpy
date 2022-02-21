import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardName extends ConsumerWidget {
  const TweetCardName({
    required this.tweet,
    required this.onUserTap,
    required this.style,
  });

  final TweetData tweet;
  final TweetActionCallback? onUserTap;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onUserTap?.call(context, ref.read),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Flexible(
              child: Text(
                tweet.user.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2!
                    .copyWith(height: 1)
                    .apply(fontSizeDelta: style.sizeDelta),
              ),
            ),
            if (tweet.user.verified) ...[
              const SizedBox(width: 4),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16 + style.sizeDelta,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
