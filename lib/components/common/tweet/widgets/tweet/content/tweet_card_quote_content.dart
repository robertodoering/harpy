import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class TweetQuoteContent extends StatelessWidget {
  const TweetQuoteContent(this.tweet);

  final TweetData tweet;

  bool _addBottomPadding(Widget child, List<Widget> content) {
    final filtered =
        content.where((element) => element is! TweetTranslation).toList();

    // tweet translation builds its own padding
    // don't add padding to last child
    return child is! TweetTranslation && child != filtered.last;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    final content = <Widget>[
      TweetTopRow(
        beginPadding: EdgeInsets.only(
          left: defaultSmallPaddingValue,
          top: defaultSmallPaddingValue,
        ),
        begin: <Widget>[
          TweetAuthorRow(
            tweet.user,
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
          tweet.text,
          entities: tweet.entities,
          style: theme.textTheme.bodyText2!.apply(fontSizeDelta: -2),
          urlToIgnore: tweet.quoteUrl,
        ),
      if (tweet.translatable(translateLanguage))
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => app<HarpyNavigator>().pushRepliesScreen(
        tweet: tweet,
      ),
      child: AnimatedContainer(
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
      ),
    );
  }
}
