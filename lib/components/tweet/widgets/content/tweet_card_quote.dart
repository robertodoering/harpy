import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardQuote extends ConsumerWidget {
  const TweetCardQuote({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    final state = ref.watch(tweetProvider(tweet.quote!));
    final notifier = ref.watch(tweetProvider(tweet.quote!).notifier);

    final delegates = TweetCard.defaultDelegates(state, notifier);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => delegates.onTweetTap?.call(context, ref.read),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: harpyTheme.borderRadius,
          border: Border.all(color: theme.dividerColor),
        ),
        child: ClipRRect(
          borderRadius: harpyTheme.borderRadius,
          child: TweetCardContent(
            tweet: state,
            delegates: delegates,
            outerPadding: display.smallPaddingValue,
            innerPadding: display.smallPaddingValue / 2,
            config: kDefaultTweetCardQuoteConfig,
          ),
        ),
      ),
    );
  }
}
