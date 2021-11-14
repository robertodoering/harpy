import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds a column of [TweetCard]s for each reply in a tweet.
///
/// The color alternates between 2 solid colors without transparency for each
/// level of replies.
/// E.g.:
/// - First tweet: normal transparent card color
/// - Replies of tweet: first solid card color
/// - Replies of reply: second solid card color
/// - Replies of reply of reply: first solid card color
class TweetCardReplies extends StatelessWidget {
  const TweetCardReplies({
    this.color,
  });

  /// The color alternated depending on the parent cards color.
  final Color? color;

  Color _cardColor(HarpyTheme harpyTheme) {
    if (color != harpyTheme.solidCardColor1) {
      return harpyTheme.solidCardColor1;
    } else {
      return harpyTheme.solidCardColor2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = context.watch<HarpyTheme>();
    final config = context.watch<ConfigCubit>().state;

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);
    final authors = tweet.replyAuthors;

    final fontSizeDelta = config.fontSizeDelta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (authors.isNotEmpty)
          Padding(
            padding: config.edgeInsets.copyWith(top: 0),
            child: Row(
              children: [
                SizedBox(
                  width: TweetCardAvatar.defaultRadius(fontSizeDelta) * 2,
                  child: Icon(CupertinoIcons.reply, size: 18 + fontSizeDelta),
                ),
                horizontalSpacer,
                Expanded(
                  child: Text(
                    '$authors replied',
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        for (final reply in tweet.replies) ...[
          TweetCard(
            reply,
            color: _cardColor(harpyTheme),
          ),
          if (reply != tweet.replies.last) verticalSpacer,
        ],
      ],
    );
  }
}
