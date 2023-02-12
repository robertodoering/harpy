import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardText extends StatelessWidget {
  const TweetCardText({
    required this.tweet,
    required this.style,
  });

  final LegacyTweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection:
          tweet.isRtlLanguage ? TextDirection.rtl : TextDirection.ltr,
      child: TwitterText(
        tweet.text,
        entities: tweet.entities,
        urlToIgnore: tweet.quoteUrl,
        style: theme.textTheme.bodyMedium!.apply(
          fontSizeDelta: style.sizeDelta,
        ),
      ),
    );
  }
}
