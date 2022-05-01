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

    final provider = tweetProvider(tweet.quote!);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    final delegates = defaultTweetDelegates(state, notifier);

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
            provider: provider,
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
