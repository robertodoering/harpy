import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef TweetDelegatesCreator = TweetDelegates Function(
  TweetData tweet,
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

  final TweetData tweet;
  final TweetCardConfig config;
  final TweetDelegatesCreator createDelegates;
  final Color? color;
  final int? index;

  @override
  _TweetCardState createState() => _TweetCardState();
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
    final display = ref.watch(displayPreferencesProvider);
    final provider = tweetProvider(widget.tweet.originalId);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    if (state == null) return const SizedBox();

    final delegates = widget.createDelegates(state, notifier);

    final child = TweetCardContent(
      tweet: state,
      notifier: notifier,
      delegates: delegates,
      outerPadding: display.paddingValue,
      innerPadding: display.smallPaddingValue,
      config: widget.config,
      index: widget.index,
    );

    return Card(
      color: widget.color,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => delegates.onShowTweet?.call(context, ref.read),
        child: state.replies.isEmpty
            ? child
            : Column(
                children: [
                  child,
                  TweetCardReplies(tweet: state, color: widget.color),
                ],
              ),
      ),
    );
  }
}
