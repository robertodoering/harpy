import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/tweet/widgets/button/translate_button.dart';

class TweetCardActions extends ConsumerWidget {
  const TweetCardActions({
    required this.tweet,
    required this.onFavorite,
    required this.onUnfavorite,
    required this.onRetweet,
    required this.onUnretweet,
    required this.onTranslate,
    required this.onShowRetweeters,
    required this.onComposeQuote,
    required this.padding,
    required this.style,
  });

  final TweetData tweet;
  final TweetActionCallback? onFavorite;
  final TweetActionCallback? onUnfavorite;
  final TweetActionCallback? onRetweet;
  final TweetActionCallback? onUnretweet;
  final TweetActionCallback? onTranslate;
  final TweetActionCallback? onShowRetweeters;
  final TweetActionCallback? onComposeQuote;
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
          onRetweet: onRetweet,
          onUnretweet: onUnretweet,
          onShowRetweeters: onShowRetweeters,
          onComposeQuote: onComposeQuote,
          sizeDelta: style.sizeDelta,
        ),
        FavoriteButton(
          tweet: tweet,
          onFavorite: onFavorite,
          onUnfavorite: onUnfavorite,
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
        //   HarpyButton.flat(
        //     onTap: bloc.onReplyToTweet,
        //     icon: const Icon(CupertinoIcons.reply),
        //     iconSize: iconSize,
        //     padding: padding,
        //   ),
        const Spacer(),
        if (tweet.translatable(translateLanguage) ||
            tweet.quoteTranslatable(translateLanguage))
          TranslateButton(
            tweet: tweet,
            onTranslate: onTranslate,
            sizeDelta: style.sizeDelta,
          ),
      ],
    );
  }
}
