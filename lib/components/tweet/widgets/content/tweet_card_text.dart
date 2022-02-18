import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardText extends StatelessWidget {
  const TweetCardText({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // TODO: text
    // final theme = Theme.of(context);

    // return TwitterText(
    //   tweet.text,
    //   entities: tweet.entities,
    //   urlToIgnore: tweet.quoteUrl,
    //   style: theme.textTheme.bodyText2!.apply(
    //     fontSizeDelta: style.sizeDelta,
    //   ),
    // );
  }
}
