import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardQuote extends ConsumerStatefulWidget {
  const TweetCardQuote({
    required this.tweet,
    this.index,
  });

  final TweetData tweet;
  final int? index;

  @override
  ConsumerState<TweetCardQuote> createState() => _TweetCardQuoteState();
}

class _TweetCardQuoteState extends ConsumerState<TweetCardQuote> {
  @override
  void initState() {
    super.initState();

    final provider = tweetProvider(widget.tweet.quote!.originalId);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(provider.notifier).initialize(widget.tweet.quote!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    final provider = tweetProvider(widget.tweet.quote!.originalId);
    final tweet = ref.watch(provider) ?? widget.tweet.quote!;
    final notifier = ref.watch(provider.notifier);

    final delegates = defaultTweetDelegates(tweet, notifier);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => delegates.onShowTweet?.call(context, ref.read),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: harpyTheme.borderRadius,
          border: Border.all(color: theme.dividerColor),
        ),
        child: ClipRRect(
          borderRadius: harpyTheme.borderRadius,
          child: TweetCardContent(
            tweet: tweet,
            notifier: notifier,
            delegates: delegates,
            outerPadding: display.smallPaddingValue,
            innerPadding: display.smallPaddingValue / 2,
            config: kDefaultTweetCardQuoteConfig,
            index: widget.index,
          ),
        ),
      ),
    );
  }
}
