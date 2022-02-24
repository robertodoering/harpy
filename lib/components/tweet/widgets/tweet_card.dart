import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

typedef TweetDelegatesCreator = TweetDelegates Function(
  TweetData tweet,
  TweetNotifier notifier,
);

typedef TweetActionCallback = void Function(
  BuildContext context,
  Reader read,
);

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
      onTweetTap: (context, read) => read(routerProvider).pushNamed(
        TweetDetailPage.name,
        extra: tweet,
      ),
      onUserTap: null,
      onRetweeterTap: null,
      onViewActions: (context, read) => showTweetActionsBottomSheet(
        context,
        tweet: tweet,
        read: read,
      ),
      onFavorite: (_, __) {
        HapticFeedback.lightImpact();
        notifier.favorite();
      },
      onUnfavorite: (_, __) {
        HapticFeedback.lightImpact();
        notifier.unfavorite();
      },
      onRetweet: (_, __) {
        HapticFeedback.lightImpact();
        notifier.retweet();
      },
      onUnretweet: (_, __) {
        HapticFeedback.lightImpact();
        notifier.unretweet();
      },
      onTranslate: (context, _) {
        HapticFeedback.lightImpact();
        notifier.translate(locale: Localizations.localeOf(context));
      },
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

    final child = TweetCardContent(
      tweet: state,
      delegates: delegates,
      outerPadding: display.paddingValue,
      innerPadding: display.smallPaddingValue,
      config: config,
    );

    return VisibilityChangeListener(
      detectorKey: ValueKey(tweet.hashCode),
      child: ListCardAnimation(
        child: Card(
          color: color,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => delegates.onTweetTap?.call(context, ref.read),
            child: state.replies.isEmpty
                ? child
                : Column(
                    children: [
                      child,
                      TweetCardReplies(tweet: state, color: color),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
