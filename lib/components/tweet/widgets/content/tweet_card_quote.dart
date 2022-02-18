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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {}, // TODO: on quote tap
      // onTap: bloc.onTweetTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: harpyTheme.borderRadius,
          border: Border.all(color: theme.dividerColor),
        ),
        child: TweetCardContent(
          outerPadding: display.smallPaddingValue,
          innerPadding: display.smallPaddingValue / 2,
          config: kDefaultTweetCardQuoteConfig,
          tweet: tweet.quote!,
        ),
      ),
    );
  }
}
