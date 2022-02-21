import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef TweetDelegatesCreator = TweetDelegates Function(
  TweetData tweet,
  TweetNotifier notifier,
);

typedef TweetActionCallback = void Function(
  BuildContext context,
  Reader read,
);

class TweetDelegates {
  const TweetDelegates({
    required this.onTweetTap,
    required this.onUserTap,
    required this.onRetweeterTap,
    required this.onViewActions,
    required this.onFavorite,
    required this.onUnfavorite,
    required this.onRetweet,
    required this.onUnretweet,
    required this.onTranslate,
    required this.onShowRetweeters,
    required this.onComposeQuote,
    required this.onComposeReply,
  });

  final TweetActionCallback? onTweetTap;
  final TweetActionCallback? onUserTap;
  final TweetActionCallback? onRetweeterTap;
  final TweetActionCallback? onViewActions;
  final TweetActionCallback? onFavorite;
  final TweetActionCallback? onUnfavorite;
  final TweetActionCallback? onRetweet;
  final TweetActionCallback? onUnretweet;
  final TweetActionCallback? onTranslate;
  final TweetActionCallback? onShowRetweeters;
  final TweetActionCallback? onComposeQuote;
  final TweetActionCallback? onComposeReply;
}

class TweetCard extends ConsumerWidget {
  const TweetCard({
    required this.tweet,
    this.createDelegates = defaultDelegates,
    this.config = kDefaultTweetCardConfig,
    this.color,
  });

  final TweetData tweet;
  final TweetCardConfig config;
  final TweetDelegatesCreator createDelegates;
  final Color? color;

  static TweetDelegates defaultDelegates(
    TweetData tweet,
    TweetNotifier notifier,
  ) {
    // TODO: implement all tweet delegates
    return TweetDelegates(
      onTweetTap: null,
      onUserTap: null,
      onRetweeterTap: null,
      onViewActions: (context, read) => showTweetActionsBottomSheet(
        context,
        tweet: tweet,
        read: read,
      ),
      onFavorite: (_, __) => notifier.favorite(),
      onUnfavorite: (_, __) => notifier.unfavorite(),
      onRetweet: (_, __) => notifier.retweet(),
      onUnretweet: (_, __) => notifier.unretweet(),
      onTranslate: (context, __) => notifier.translate(
        languageCode: Localizations.localeOf(context).languageCode,
      ),
      onShowRetweeters: null,
      onComposeQuote: null,
      onComposeReply: null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final state = ref.watch(tweetProvider(tweet));
    final notifier = ref.watch(tweetProvider(tweet).notifier);

    final delegates = createDelegates(state, notifier);

    // TODO: build replies

    return Card(
      color: color,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => delegates.onTweetTap?.call(context, ref.read),
        child: TweetCardContent(
          tweet: state,
          delegates: delegates,
          outerPadding: display.paddingValue,
          innerPadding: display.smallPaddingValue,
          config: config,
        ),
      ),
    );
  }
}
