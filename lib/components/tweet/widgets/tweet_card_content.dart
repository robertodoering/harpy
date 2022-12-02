import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardContent extends ConsumerWidget {
  const TweetCardContent({
    required this.tweet,
    required this.notifier,
    required this.delegates,
    required this.outerPadding,
    required this.innerPadding,
    required this.config,
    this.index,
  });

  final LegacyTweetData tweet;
  final TweetNotifier notifier;
  final TweetDelegates delegates;
  final double outerPadding;
  final double innerPadding;
  final TweetCardConfig config;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final translateLanguage =
        ref.watch(languagePreferencesProvider).activeTranslateLanguage(locale);

    final text = TweetCardElement.text.shouldBuild(tweet, config);
    final translation = TweetCardElement.translation.shouldBuild(tweet, config);
    final media = TweetCardElement.media.shouldBuild(tweet, config);
    final quote = TweetCardElement.quote.shouldBuild(tweet, config);
    final linkPreview = TweetCardElement.linkPreview.shouldBuild(tweet, config);
    final details = TweetCardElement.details.shouldBuild(tweet, config);
    final actionsRow = TweetCardElement.actionsRow.shouldBuild(tweet, config);

    final content = {
      TweetCardElement.topRow: TweetCardTopRow(
        tweet: tweet,
        delegates: delegates,
        outerPadding: outerPadding,
        innerPadding: innerPadding,
        config: config,
      ),
      if (text)
        TweetCardElement.text: TweetCardText(
          tweet: tweet,
          style: TweetCardElement.text.style(config),
        ),
      if (translation && tweet.translatable(translateLanguage))
        TweetCardElement.translation: TweetCardTranslation(
          tweet: tweet,
          outerPadding: outerPadding,
          innerPadding: innerPadding,
          requireBottomInnerPadding: media || quote || details,
          requireBottomOuterPadding: !(media || quote || actionsRow || details),
          style: TweetCardElement.translation.style(config),
        ),
      if (media)
        TweetCardElement.media: TweetCardMedia(
          tweet: tweet,
          delegates: delegates,
          index: index,
        ),
      if (quote)
        TweetCardElement.quote: TweetCardQuote(
          tweet: tweet,
          index: index,
        ),
      if (linkPreview)
        TweetCardElement.linkPreview: TweetCardLinkPreview(tweet: tweet),
      if (details)
        TweetCardElement.details: TweetCardDetails(
          tweet: tweet,
          style: TweetCardElement.details.style(config),
        ),
      if (actionsRow)
        TweetCardElement.actionsRow: TweetCardActions(
          tweet: tweet,
          delegates: delegates,
          actions: config.actions,
          padding: EdgeInsets.all(outerPadding),
          style: TweetCardElement.actionsRow.style(config),
        ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          ],
        ],
      ],
    );
  }
}
