import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class TweetCardReplies extends ConsumerWidget {
  const TweetCardReplies({
    required this.tweet,
    required this.color,
  });

  final LegacyTweetData tweet;

  /// The color alternated depending on the parent cards color.
  final Color? color;

  Color _cardColor(HarpyTheme harpyTheme) {
    return color != harpyTheme.colors.solidCardColor1
        ? harpyTheme.colors.solidCardColor1
        : harpyTheme.colors.solidCardColor2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tweet.replyAuthors.isNotEmpty)
          Padding(
            padding: theme.spacing.edgeInsets.copyWith(top: 0),
            child: Row(
              children: [
                SizedBox(
                  width:
                      TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
                  child: Icon(
                    CupertinoIcons.reply,
                    size: 18 + display.fontSizeDelta,
                  ),
                ),
                HorizontalSpacer.normal,
                Expanded(
                  child: Text(
                    '${tweet.replyAuthors} replied',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        for (final reply in tweet.replies) ...[
          TweetCard(
            tweet: reply,
            color: _cardColor(harpyTheme),
          ),
          if (reply != tweet.replies.last) VerticalSpacer.normal,
        ],
      ],
    );
  }
}
