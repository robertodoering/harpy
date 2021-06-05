import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TweetCardContent extends StatelessWidget {
  const TweetCardContent();

  bool _addBottomPadding(Widget child, List<Widget> content) {
    final filtered =
        content.where((element) => element is! TweetTranslation).toList();

    // tweet translation builds its own padding
    // don't add padding to last and second to last child
    return child is! TweetTranslation &&
        child != content.last &&
        child != filtered[filtered.length - 2];
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    final route = ModalRoute.of(context)!.settings;
    final locale = Localizations.localeOf(context);
    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    final content = [
      TweetTopRow(
        beginPadding: DefaultEdgeInsets.only(left: true, top: true),
        begin: <Widget>[
          if (tweet.isRetweet) ...<Widget>[
            TweetRetweetedRow(tweet),
            AnimatedContainer(
              duration: kLongAnimationDuration,
              height: defaultSmallPaddingValue,
            ),
          ],
          TweetAuthorRow(tweet.user, createdAt: tweet.createdAt),
        ],
        end: TweetActionsButton(tweet, padding: DefaultEdgeInsets.all()),
      ),
      if (tweet.hasText)
        TwitterText(
          tweet.text,
          entities: tweet.entities,
          urlToIgnore: tweet.quoteUrl,
        ),
      if (tweet.translatable(translateLanguage))
        TweetTranslation(
          tweet,
          padding: EdgeInsets.only(
            top: !(tweet.hasMedia || tweet.hasQuote)
                ? defaultSmallPaddingValue
                : 0,
            bottom:
                tweet.hasMedia || tweet.hasQuote ? defaultSmallPaddingValue : 0,
          ),
        ),
      if (tweet.hasMedia) TweetMedia(tweet),
      if (tweet.hasQuote) TweetQuoteContent(tweet.quote!),
      TweetActionRow(tweet),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap:
          !tweet.currentReplyParent(route) ? () => bloc.onCardTap(tweet) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in content) ...[
            if (child == content.first || child == content.last)
              child
            else
              AnimatedPadding(
                duration: kShortAnimationDuration,
                padding: DefaultEdgeInsets.only(left: true, right: true),
                child: child,
              ),
            if (_addBottomPadding(child, content))
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
