import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/actions_button.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/top_row.dart';
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
      TweetTopRow(
        beginPadding: EdgeInsets.only(
          left: defaultPaddingValue / 2,
          top: defaultPaddingValue / 2,
        ),
        begin: <Widget>[
          if (tweet.isRetweet) ...<Widget>[
            TweetAuthorRow(
              tweet.userData,
              createdAt: tweet.createdAt,
              avatarPadding: defaultPaddingValue / 2,
              avatarRadius: 18,
              fontSizeDelta: -2,
              iconSize: 14,
            ),
          ],
          TweetAuthorRow(tweet.userData, createdAt: tweet.createdAt),
        ],
        end: TweetActionsButton(
          tweet,
          padding: EdgeInsets.all(defaultPaddingValue / 2),
          sizeDelta: -2,
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (Widget child in content) ...<Widget>[
            if (child == content.first)
              child
            else
              AnimatedPadding(
                duration: kShortAnimationDuration,
                padding: EdgeInsets.only(
                  left: defaultSmallPaddingValue,
                  right: defaultSmallPaddingValue,
                ),
                child: child,
              ),
            if (child is! TweetTranslation && child != content.last)
              AnimatedContainer(
                duration: kShortAnimationDuration,
                height: defaultSmallPaddingValue / 2,
              )
            else if (child == content.last)
              AnimatedContainer(
                duration: kShortAnimationDuration,
                height: defaultSmallPaddingValue,
              ),
          ],
        ],
      ),
    );
  }
}
