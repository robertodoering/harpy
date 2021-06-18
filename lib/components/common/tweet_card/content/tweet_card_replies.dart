import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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

  Color? _cardColor(ThemeData theme) {
    final color1 = Color.lerp(
      theme.scaffoldBackgroundColor,
      theme.accentColor,
      .225,
    );

    if (color != color1) {
      return color1;
    } else {
      return Color.lerp(
        theme.scaffoldBackgroundColor,
        theme.accentColor,
        .15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tweet.replyAuthors.isNotEmpty)
          Padding(
            padding: DefaultEdgeInsets.all().copyWith(top: 0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: TweetCardAvatar.defaultRadius * 2,
                  child: Icon(CupertinoIcons.reply, size: 18 + fontSizeDelta),
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
        for (final tweet in tweet.replies) ...[
          TweetCard(
            tweet,
            color: _cardColor(theme),
          ),
          if (tweet != tweet.replies.last) defaultVerticalSpacer,
        ],
      ],
    );
  }
}
