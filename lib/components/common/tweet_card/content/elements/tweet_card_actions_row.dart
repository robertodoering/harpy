import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class TweetCardActionsRow extends StatelessWidget {
  const TweetCardActionsRow({
    required this.padding,
    required this.style,
  });

  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.tweet;

    final iconSize = iconTheme.size! + 2 + style.sizeDelta;

    final locale = Localizations.localeOf(context);
    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    return Row(
      children: [
        RetweetButton(
          padding: padding,
          iconSize: iconSize - 1,
          sizeDelta: style.sizeDelta,
        ),
        FavoriteButton(
          padding: padding,
          iconSize: iconSize,
          sizeDelta: style.sizeDelta,
        ),
        if (!tweet.currentReplyParent(context))
          HarpyButton.flat(
            onTap: bloc.onTweetTap,
            icon: const Icon(CupertinoIcons.bubble_left),
            iconSize: iconSize,
            padding: padding,
          )
        else
          HarpyButton.flat(
            onTap: bloc.onReplyToTweet,
            icon: const Icon(CupertinoIcons.reply),
            iconSize: iconSize,
            padding: padding,
          ),
        const Spacer(),
        if (tweet.translatable(translateLanguage) ||
            tweet.quoteTranslatable(translateLanguage))
          TweetTranslationButton(
            padding: padding,
            iconSize: iconSize,
            sizeDelta: style.sizeDelta,
          ),
      ],
    );
  }
}
