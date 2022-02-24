import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardDetails extends StatelessWidget {
  const TweetCardDetails({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;

    final date = l10n.formatFullDate(tweet.createdAt.toLocal());

    final time = l10n.formatTimeOfDay(
      TimeOfDay.fromDateTime(tweet.createdAt.toLocal()),
    );

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
