import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

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

  Color? _cardColor(HarpyTheme harpyTheme) {
    if (depth.isEven) {
      return Color.lerp(
        harpyTheme.averageBackgroundColor,
        harpyTheme.accentColor,
        .225,
      );
    } else {
      return Color.lerp(
        harpyTheme.averageBackgroundColor,
        harpyTheme.accentColor,
        .15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = HarpyTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tweet.replyAuthors.isNotEmpty)
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
                  child: const Icon(CupertinoIcons.reply, size: 18),
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
