import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCard extends ConsumerWidget {
  const TweetCard({
    required this.tweet,
    this.config = kDefaultTweetCardConfig,
    this.color,
  });

  final TweetData tweet;
  final TweetCardConfig config;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final state = ref.watch(tweetProvider(tweet));

    // TODO: build replies
    // TODO: provide delegates

    return Card(
      color: color,
      child: TweetCardContent(
        tweet: state,
        outerPadding: display.paddingValue,
        innerPadding: display.smallPaddingValue,
        config: kDefaultTweetCardConfig,
      ),
    );
  }
}
