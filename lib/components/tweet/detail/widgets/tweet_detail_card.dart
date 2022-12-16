import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TweetDetailCard extends StatelessWidget {
  const TweetDetailCard({
    required this.tweet,
  });

  final LegacyTweetData tweet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: theme.spacing.edgeInsets.copyWith(top: 0),
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
