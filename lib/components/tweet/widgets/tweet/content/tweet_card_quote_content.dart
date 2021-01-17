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

  bool _addBottomPadding(Widget child, List<Widget> content) {
    final List<Widget> filtered = content
        .where((Widget element) => element is! TweetTranslation)
        .toList();

    // tweet translation builds its own padding
    // don't add padding to last child
    return child is! TweetTranslation && child != filtered.last;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      TweetTopRow(
        beginPadding: EdgeInsets.only(
          left: defaultSmallPaddingValue,
          top: defaultSmallPaddingValue,
        ),
        begin: <Widget>[
          TweetAuthorRow(
            tweet.userData,
            createdAt: tweet.createdAt,
            avatarPadding: defaultSmallPaddingValue,
            avatarRadius: 18,
            fontSizeDelta: -2,
            iconSize: 14,
          ),
        ],
        end: TweetActionsButton(
          tweet,
          padding: EdgeInsets.all(defaultSmallPaddingValue),
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
      if (tweet.translatable)
        TweetTranslation(
          tweet,
          fontSizeDelta: -2,
          padding: EdgeInsets.only(
            top: !tweet.hasMedia ? defaultSmallPaddingValue / 2 : 0,
            bottom: tweet.hasMedia ? defaultSmallPaddingValue / 2 : 0,
          ),
        ),
      if (tweet.hasMedia) TweetMedia(tweet),
    ];

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        border: Border.all(color: theme.dividerColor),
      ),
      padding: EdgeInsets.only(bottom: defaultSmallPaddingValue),
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
            if (_addBottomPadding(child, content))
              AnimatedContainer(
                duration: kShortAnimationDuration,
                height: defaultSmallPaddingValue / 2,
              )
          ],
        ],
      ),
    );
  }
}
