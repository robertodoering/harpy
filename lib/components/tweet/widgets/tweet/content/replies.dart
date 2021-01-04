import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_card.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds [TweetCard]s for the replies in [tweet].
///
/// [TweetData.replyAuthors] are built above the [TweetCard]s if they exist.
class TweetReplies extends StatelessWidget {
  const TweetReplies(
    this.tweet, {
    this.depth = 0,
  });

  final TweetData tweet;
  final int depth;

  Color _cardColor(HarpyTheme harpyTheme) {
    final Color color1 = Color.lerp(
      harpyTheme.averageBackgroundColor,
      harpyTheme.accentColor,
      .225,
    );

    final Color color2 = Color.lerp(
      harpyTheme.averageBackgroundColor,
      harpyTheme.accentColor,
      .15,
    );

    return depth % 2 == 0 ? color1 : color2;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tweet.replyAuthors?.isNotEmpty == true)
          AnimatedPadding(
            duration: kShortAnimationDuration,
            padding: DefaultEdgeInsets.only(
              left: true,
              right: true,
              bottom: true,
            ),
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: kShortAnimationDuration,
                  width: TweetAuthorRow.defaultAvatarRadius * 2,
                  child: const Icon(Icons.reply, size: 18),
                ),
                defaultHorizontalSpacer,
                Expanded(
                  child: Text(
                    '${tweet.replyAuthors} replied',
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        for (int i = 0; i < tweet.replies.length; i++) ...<Widget>[
          TweetCard(
            tweet.replies[i],
            color: _cardColor(harpyTheme),
            depth: depth + 1,
          ),
          if (i < tweet.replies.length - 1) defaultVerticalSpacer,
        ],
      ],
    );
  }
}
