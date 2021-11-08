import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

/// Builds the content for the tweet of a [TweetBloc], including padding and
/// layout.
///
/// Actions such as liking, retweeting and tapping on the tweet are delegated to
/// the parent [TweetBloc].
class TweetCardContent extends StatelessWidget {
  const TweetCardContent({
    required this.outerPadding,
    required this.innerPadding,
    required this.config,
  });

  final double outerPadding;
  final double innerPadding;

  final TweetCardConfig config;

  @override
  Widget build(BuildContext context) {
    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final locale = Localizations.localeOf(context);
    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    final text = TweetCardElement.text.shouldBuild(tweet, config);
    final translation = TweetCardElement.translation.shouldBuild(tweet, config);
    final media = TweetCardElement.media.shouldBuild(tweet, config);
    final quote = TweetCardElement.quote.shouldBuild(tweet, config);
    final details = TweetCardElement.details.shouldBuild(tweet, config);
    final actionsRow = TweetCardElement.actionsRow.shouldBuild(tweet, config);

    final content = {
      TweetCardElement.topRow: TweetCardTopRow(
        outerPadding: outerPadding,
        innerPadding: innerPadding,
        config: config,
      ),
      if (text)
        TweetCardElement.text: TweetCardText(
          style: TweetCardElement.text.style(config),
        ),
      if (translation && tweet.translatable(translateLanguage))
        TweetCardElement.translation: TweetCardTranslation(
          outerPadding: outerPadding,
          innerPadding: innerPadding,
          requireBottomInnerPadding: media || quote || details,
          requireBottomOuterPadding: !(media || quote || actionsRow || details),
          style: TweetCardElement.translation.style(config),
        ),
      if (media) TweetCardElement.media: const TweetMedia(),
      if (quote) TweetCardElement.quote: const TweetCardQuote(),
      if (details)
        TweetCardElement.details: TweetCardDetails(
          style: TweetCardElement.details.style(config),
        ),
      if (actionsRow)
        TweetCardElement.actionsRow: TweetCardActionsRow(
          padding: EdgeInsets.all(outerPadding),
          style: TweetCardElement.actionsRow.style(config),
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < content.length; i++) ...[
          if (!content.keys.elementAt(i).requiresPadding)
            content.values.elementAt(i)
          else ...[
            if (i == 0) SizedBox(height: outerPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPadding),
              child: content.values.elementAt(i),
            ),
            if (content.keys.elementAt(i).buildBottomPadding(i, content.keys))
              SizedBox(
                height: i == content.length - 1 ? outerPadding : innerPadding,
              ),
          ]
        ]
      ],
    );
  }
}
