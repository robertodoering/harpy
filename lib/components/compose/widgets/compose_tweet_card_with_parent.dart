import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class ComposeTweetCardWithParent extends StatelessWidget {
  const ComposeTweetCardWithParent({
    this.parentTweet,
    this.quotedTweet,
  }) : assert(parentTweet == null || quotedTweet == null);

  final LegacyTweetData? parentTweet;
  final LegacyTweetData? quotedTweet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ComposeTweetCard(),
        VerticalSpacer.normal,
        if (parentTweet != null)
          _ParentTweetCard(
            tweet: parentTweet!,
            label: 'replying to',
          )
        else if (quotedTweet != null)
          _ParentTweetCard(
            tweet: quotedTweet!,
            label: 'quoting',
          ),
      ],
    );
  }
}

class _ParentTweetCard extends ConsumerWidget {
  const _ParentTweetCard({
    required this.tweet,
    required this.label,
  });

  final LegacyTweetData tweet;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.base,
            vertical: theme.spacing.small,
          ),
          child: Row(
            children: [
              SizedBox(
                width: TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
                child: const Icon(CupertinoIcons.reply, size: 18),
              ),
              HorizontalSpacer.normal,
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        VerticalSpacer.normal,
        TweetCard(
          tweet: tweet,
          createDelegates: (tweet, notifier) =>
              defaultTweetDelegates(tweet, notifier).copyWith(
            onComposeQuote: null,
            onComposeReply: null,
          ),
        ),
      ],
    );
  }
}
