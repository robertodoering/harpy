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

  final LegacyTweetData tweet;
  final TweetActionCallback? onUserTap;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onUserTap?.call(ref),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Flexible(
              child: FittedBox(
                child: Text(
                  // The additional space prevents an issue where a name
                  // consisting of only zero width characters cause the
                  // rendering of the fitted box to throw exceptions due to the
                  // text having a width of 0.
                  '${tweet.user.name} ',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(height: 1)
                      .apply(fontSizeDelta: style.sizeDelta),
                ),
              ),
            ),
            if (tweet.user.isVerified) ...[
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16 + style.sizeDelta,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
