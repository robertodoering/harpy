import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TweetCardDetails extends StatelessWidget {
  const TweetCardDetails({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final date = DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
        .format(tweet.createdAt.toLocal())
        .toLowerCase();

    final time = DateFormat.Hm(Localizations.localeOf(context).languageCode)
        .format(tweet.createdAt.toLocal())
        .toLowerCase();

    final textStyle = theme.textTheme.bodyText2!.apply(
      color: theme.textTheme.bodyText1!.color,
      fontSizeDelta: style.sizeDelta,
    );

    return Column(
      children: [
        smallVerticalSpacer,
        Wrap(
          children: [
            Text(time, style: textStyle),
            Text(' \u00b7 ', style: textStyle),
            Text(date, style: textStyle),
            if (tweet.hasSource) ...[
              Text(' \u00b7 ', style: textStyle),
              Text(tweet.source, style: textStyle),
            ],
          ],
        ),
      ],
    );
  }
}
