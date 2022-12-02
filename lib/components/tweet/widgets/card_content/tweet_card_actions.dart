import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/tweet/widgets/button/replies_button.dart';

class TweetCardActions extends ConsumerWidget {
  const TweetCardActions({
    required this.tweet,
    required this.delegates,
    required this.actions,
    required this.padding,
    required this.style,
  });

  final LegacyTweetData tweet;
  final TweetDelegates delegates;
  final Set<TweetCardActionElement> actions;
  final EdgeInsets padding;
  final TweetCardElementStyle style;

  Widget? _mapAction({
    required BuildContext context,
    required WidgetRef ref,
    required TweetCardActionElement action,
  }) {
    switch (action) {
      case TweetCardActionElement.retweet:
        return RetweetButton(
          tweet: tweet,
          onRetweet: delegates.onRetweet,
          onUnretweet: delegates.onUnretweet,
          onShowRetweeters: delegates.onShowRetweeters,
          onComposeQuote: delegates.onComposeQuote,
          sizeDelta: style.sizeDelta,
        );
      case TweetCardActionElement.favorite:
        return FavoriteButton(
          tweet: tweet,
          onFavorite: delegates.onFavorite,
          onUnfavorite: delegates.onUnfavorite,
          sizeDelta: style.sizeDelta,
        );
      case TweetCardActionElement.showReplies:
        return Repliesbutton(
          tweet: tweet,
          onShowReplies: delegates.onShowTweet,
        );
      case TweetCardActionElement.reply:
        return Replybutton(
          tweet: tweet,
          onComposeReply: delegates.onComposeReply,
        );

      case TweetCardActionElement.translate:
        final locale = Localizations.localeOf(context);

        final translateLanguage = ref
            .watch(languagePreferencesProvider)
            .activeTranslateLanguage(locale);

        if (tweet.translatable(translateLanguage) ||
            tweet.quoteTranslatable(translateLanguage)) {
          return TranslateButton(
            tweet: tweet,
            onTranslate: delegates.onTranslate,
            sizeDelta: style.sizeDelta,
          );
        } else {
          return null;
        }
      case TweetCardActionElement.spacer:
        return const Spacer();
      case TweetCardActionElement.openExternally:
      case TweetCardActionElement.copyText:
      case TweetCardActionElement.share:
        throw UnsupportedError('action not implemented');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = <Widget>[];

    for (final action in actions) {
      final child = _mapAction(context: context, ref: ref, action: action);

      if (child != null) children.add(child);
    }

    return Row(
      children: children,
    );
  }
}
