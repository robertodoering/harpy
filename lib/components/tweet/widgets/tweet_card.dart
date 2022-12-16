import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

typedef TweetDelegatesCreator = TweetDelegates Function(
  LegacyTweetData tweet,
  TweetNotifier notifier,
);

class TweetCard extends ConsumerStatefulWidget {
  TweetCard({
    required this.tweet,
    this.createDelegates = defaultTweetDelegates,
    this.config = kDefaultTweetCardConfig,
    this.color,
    this.index,
  }) : super(key: ObjectKey(tweet));

  final LegacyTweetData tweet;
  final TweetCardConfig config;
  final TweetDelegatesCreator createDelegates;
  final Color? color;
  final int? index;

  @override
  ConsumerState<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends ConsumerState<TweetCard> {
  @override
  void initState() {
    super.initState();

    final provider = tweetProvider(widget.tweet.originalId);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(provider.notifier).initialize(widget.tweet);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = tweetProvider(widget.tweet.originalId);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    final tweet = state ?? widget.tweet;

    final delegates = widget.createDelegates(tweet, notifier);

    final child = TweetCardContent(
      tweet: tweet,
      notifier: notifier,
      delegates: delegates,
      outerPadding: theme.spacing.base,
      innerPadding: theme.spacing.small,
      config: widget.config,
      index: widget.index,
    );

    return Card(
      color: widget.color,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => delegates.onShowTweet?.call(ref),
        child: tweet.replies.isEmpty
            ? child
            : Column(
                children: [
                  child,
                  TweetCardReplies(tweet: tweet, color: widget.color),
                ],
              ),
      ),
    );
  }
}
