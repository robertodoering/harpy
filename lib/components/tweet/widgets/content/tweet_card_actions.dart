import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardActions extends ConsumerWidget {
  const TweetCardActions({
    required this.tweet,
    required this.padding,
    required this.style,
  });

  final TweetData tweet;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final iconTheme = IconTheme.of(context);

    // final iconSize = iconTheme.size! + 2 + style.sizeDelta;

    // final locale = Localizations.localeOf(context);
    // final translateLanguage = ref
    //     .watch(languagePreferencesProvider)
    //     .activeTranslateLanguage(locale.languageCode);

    return Row(
      children: const [
        SizedBox(),
        // TODO: buttons
        // RetweetButton(
        //   padding: padding,
        //   iconSize: iconSize - 1,
        //   sizeDelta: style.sizeDelta,
        // ),
        // FavoriteButton(
        //   padding: padding,
        //   iconSize: iconSize,
        //   sizeDelta: style.sizeDelta,
        // ),
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
        // const Spacer(),
        // if (tweet.translatable(translateLanguage) ||
        //     tweet.quoteTranslatable(translateLanguage))
        //   TweetTranslationButton(
        //     padding: padding,
        //     iconSize: iconSize,
        //     sizeDelta: style.sizeDelta,
        //   ),
      ],
    );
  }
}
