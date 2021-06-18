import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

class TweetCardText extends StatelessWidget {
  const TweetCardText({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return TwitterText(
      tweet.text,
      entities: tweet.entities,
      urlToIgnore: tweet.quoteUrl,
      style: theme.textTheme.bodyText2!.apply(
        fontSizeDelta: fontSizeDelta + style.sizeDelta,
      ),
    );
  }
}
