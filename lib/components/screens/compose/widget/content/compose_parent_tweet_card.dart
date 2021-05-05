import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ComposeParentTweetCard extends StatelessWidget {
  const ComposeParentTweetCard({
    required this.parentTweet,
    required this.text,
  });

  final TweetData parentTweet;
  final String text;

  Widget _buildParentText(ThemeData theme) {
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
              text,
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
        _buildParentText(theme),
        defaultVerticalSpacer,
        TweetCard(parentTweet),
      ],
    );
  }
}
