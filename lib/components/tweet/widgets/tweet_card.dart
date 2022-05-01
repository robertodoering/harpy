import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

typedef TweetDelegatesCreator = TweetDelegates Function(
  TweetData tweet,
  TweetNotifier notifier,
);

class TweetCard extends ConsumerWidget {
  const TweetCard({
    required this.tweet,
    this.createDelegates = defaultTweetDelegates,
    this.config = kDefaultTweetCardConfig,
    this.color,
  });

  final TweetData tweet;
  final TweetCardConfig config;
  final TweetDelegatesCreator createDelegates;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final provider = tweetProvider(tweet);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    final delegates = createDelegates(state, notifier);

    final child = TweetCardContent(
      provider: provider,
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
            onTap: () => delegates.onShowTweet?.call(context, ref.read),
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
