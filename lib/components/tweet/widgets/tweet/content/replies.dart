import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_card.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds [TweetCard]s for the replies in [tweet].
///
/// [TweetData.replyAuthors] are built above the [TweetCard]s if they exist.
class TweetReplies extends StatelessWidget {
  const TweetReplies(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                Text(
                  '${tweet.replyAuthors} replied',
                  style: theme.textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ...tweet.replies.map((TweetData reply) => TweetCard(reply)),
      ],
    );
  }
}
