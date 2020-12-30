import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/actions_button.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/translation.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

class TweetQuoteContent extends StatelessWidget {
  const TweetQuoteContent(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TweetAuthorRow(
              tweet.userData,
              createdAt: tweet.createdAt,
              avatarPadding: defaultPaddingValue / 2,
              avatarRadius: 18,
              fontSizeDelta: -2,
              iconSize: 14,
            ),
          ),
          TweetActionsButton(tweet, sizeDelta: -2),
        ],
      ),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          style: theme.textTheme.bodyText2.apply(fontSizeDelta: -2),
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.translatable) TweetTranslation(tweet, fontSizeDelta: -2),
      if (tweet.hasMedia) TweetMedia(tweet),
    ];

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        border: Border.all(color: theme.dividerColor),
      ),
      padding: EdgeInsets.only(
        top: defaultPaddingValue / 2,
        left: defaultPaddingValue / 2,
        right: defaultPaddingValue / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (Widget child in content) ...<Widget>[
            child,
            if (child == content.last)
              AnimatedContainer(
                duration: kShortAnimationDuration,
                height: defaultPaddingValue / 2,
              )
            else
              AnimatedContainer(
                duration: kShortAnimationDuration,
                height: defaultPaddingValue / 4,
              ),
          ],
        ],
      ),
    );
  }
}
