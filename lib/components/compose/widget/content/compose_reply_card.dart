import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_card.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

class ComposeReplyCard extends StatelessWidget {
  const ComposeReplyCard({
    @required this.inReplyToStatus,
  });

  final TweetData inReplyToStatus;

  Widget _buildReplyingText(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPaddingValue,
        vertical: defaultSmallPaddingValue,
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: TweetAuthorRow.defaultAvatarRadius * 2,
            child: Icon(CupertinoIcons.reply, size: 18),
          ),
          defaultHorizontalSpacer,
          Expanded(
            child: Text(
              'replying to',
              style: theme.textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildReplyingText(theme),
        defaultVerticalSpacer,
        TweetCard(inReplyToStatus),
      ],
    );
  }
}
