import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final config = context.watch<ConfigBloc>().state;

    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.tweet;

    final fontSizeDelta = config.fontSizeDelta + style.sizeDelta;
    final iconSize = 22 + fontSizeDelta;

    final locale = Localizations.localeOf(context);
    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    return Row(
      children: [
        RetweetButton(
          bloc,
          padding: padding,
          iconSize: iconSize - 1,
          sizeDelta: style.sizeDelta,
        ),
        FavoriteButton(
          bloc,
          padding: padding,
          iconSize: iconSize,
          sizeDelta: style.sizeDelta,
        ),
        if (!tweet.currentReplyParent(context))
          HarpyButton.flat(
            onTap: bloc.onTweetTap,
            icon: const Icon(CupertinoIcons.bubble_left),
            iconSize: iconSize + fontSizeDelta,
            padding: padding,
          )
        else
          HarpyButton.flat(
            onTap: bloc.onReplyToTweet,
            icon: const Icon(CupertinoIcons.reply),
            iconSize: iconSize + fontSizeDelta,
            padding: padding,
          ),
        const Spacer(),
        if (tweet.translatable(translateLanguage) ||
            tweet.quoteTranslatable(translateLanguage))
          TweetTranslationButton(
            bloc,
            padding: padding,
            iconSize: iconSize,
            sizeDelta: style.sizeDelta,
          ),
      ],
    );
  }
}
