import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TweetCardDetails extends StatelessWidget {
  const TweetCardDetails({
    required this.tweet,
    required this.style,
  });

  final LegacyTweetData tweet;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer.small,
        Wrap(
          children: [
            Text(time, style: textStyle),
            Text(' \u00b7 ', style: textStyle),
            Text(date, style: textStyle),
          ],
        ),
        if (tweet.source.isNotEmpty) Text(tweet.source, style: textStyle),
      ],
    );
  }
}
