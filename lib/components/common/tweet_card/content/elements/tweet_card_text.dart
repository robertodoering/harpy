import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetCardText extends StatelessWidget {
  const TweetCardText({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    return TwitterText(
      tweet.text,
      entities: tweet.entities,
      urlToIgnore: tweet.quoteUrl,
      style: theme.textTheme.bodyText2!.apply(
        fontSizeDelta: style.sizeDelta,
      ),
    );
  }
}
