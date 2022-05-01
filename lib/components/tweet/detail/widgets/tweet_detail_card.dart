import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetDetailCard extends ConsumerWidget {
  const TweetDetailCard({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverPadding(
      padding: display.edgeInsets.copyWith(top: 0),
      sliver: SliverToBoxAdapter(
        child: TweetCard(
          tweet: tweet,
          createDelegates: (tweet, notifier) {
            return defaultTweetDelegates(tweet, notifier).copyWith(
              onShowTweet: null,
            );
          },
          config: _detailTweetCardConfig,
        ),
      ),
    );
  }
}

final _detailTweetCardConfig = kDefaultTweetCardConfig.copyWith(
  elements: {
    ...kDefaultTweetCardConfig.elements,
    TweetCardElement.details,
  },
  actions: {
    TweetCardActionElement.retweet,
    TweetCardActionElement.favorite,
    TweetCardActionElement.reply,
    TweetCardActionElement.spacer,
    TweetCardActionElement.translate,
  },
);
