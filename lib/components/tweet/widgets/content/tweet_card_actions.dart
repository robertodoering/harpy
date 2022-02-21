import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardActions extends ConsumerWidget {
  const TweetCardActions({
    required this.tweet,
    required this.delegates,
    required this.padding,
    required this.style,
  });

  final TweetData tweet;
  final TweetDelegates delegates;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);

    final translateLanguage = ref
        .watch(languagePreferencesProvider)
        .activeTranslateLanguage(locale.languageCode);

    return Row(
      children: [
        RetweetButton(
          tweet: tweet,
          onRetweet: delegates.onRetweet,
          onUnretweet: delegates.onUnretweet,
          onShowRetweeters: delegates.onShowRetweeters,
          onComposeQuote: delegates.onComposeQuote,
          sizeDelta: style.sizeDelta,
        ),
        FavoriteButton(
          tweet: tweet,
          onFavorite: delegates.onFavorite,
          onUnfavorite: delegates.onUnfavorite,
          sizeDelta: style.sizeDelta,
        ),
        // TODO: buttons
        // if (!tweet.currentReplyParent(context))
        //   HarpyButton.flat(
        //     onTap: bloc.onTweetTap,
        //     icon: const Icon(CupertinoIcons.bubble_left),
        //     iconSize: iconSize,
        //     padding: padding,
        //   )
        // else
        Replybutton(
          tweet: tweet,
          onComposeReply: delegates.onComposeReply,
        ),
        const Spacer(),
        if (tweet.translatable(translateLanguage) ||
            tweet.quoteTranslatable(translateLanguage))
          TranslateButton(
            tweet: tweet,
            onTranslate: delegates.onTranslate,
            sizeDelta: style.sizeDelta,
          ),
      ],
    );
  }
}
