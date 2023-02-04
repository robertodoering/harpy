import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCardHandle extends ConsumerWidget {
  const TweetCardHandle({
    required this.tweet,
    required this.onUserTap,
    required this.style,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onUserTap;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final directionality = Directionality.of(context);

    final textSpans = [
      TextSpan(
        text: '@${tweet.user.handle}',
        style: theme.textTheme.bodyLarge!
            .copyWith(height: 1)
            .apply(fontSizeDelta: style.sizeDelta),
      ),
      TextSpan(
        text: ' \u00b7 ',
        style: theme.textTheme.bodyLarge!
            .copyWith(height: 1)
            .apply(fontSizeDelta: style.sizeDelta),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: display.absoluteTweetTime
            ? _CreatedAtAbsoluteTime(
                localCreatedAt: tweet.createdAt.toLocal(),
                sizeDelta: style.sizeDelta,
              )
            : _CreatedAtRelativeTime(
                localCreatedAt: tweet.createdAt.toLocal(),
                sizeDelta: style.sizeDelta,
              ),
      ),
    ];

    return FittedBox(
      child: GestureDetector(
        onTap: () => onUserTap?.call(ref),
        child: Text.rich(
          // we force the text direction to ltr, otherwise the `@handle` gets
          // reversed to `handle@` for rtl languages
          textDirection: TextDirection.ltr,
          TextSpan(
            children: [
              ...directionality == TextDirection.ltr
                  ? textSpans
                  : textSpans.reversed,
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedAtRelativeTime extends StatefulWidget {
  const _CreatedAtRelativeTime({
    required this.localCreatedAt,
    this.sizeDelta = 0,
  });

  final DateTime localCreatedAt;
  final double sizeDelta;

  @override
  _CreatedAtRelativeTimeState createState() => _CreatedAtRelativeTimeState();
}

class _CreatedAtRelativeTimeState extends State<_CreatedAtRelativeTime> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final difference = DateTime.now().difference(widget.localCreatedAt);

    if (difference < const Duration(hours: 1)) {
      // update every minute
      _timer = Timer.periodic(const Duration(minutes: 1), _rebuild);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _rebuild(Timer timer) {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Text(
      timeago.format(widget.localCreatedAt, locale: languageCode),
      textDirection: TextDirection.ltr,
      style: theme.textTheme.bodyLarge!
          .copyWith(height: 1)
          .apply(fontSizeDelta: widget.sizeDelta),
    );
  }
}

class _CreatedAtAbsoluteTime extends ConsumerWidget {
  const _CreatedAtAbsoluteTime({
    required this.localCreatedAt,
    this.sizeDelta = 0,
  });

  final DateTime localCreatedAt;
  final double sizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;
    final general = ref.watch(generalPreferencesProvider);

    final date = l10n.formatCompactDate(localCreatedAt);
    final time = l10n.formatTimeOfDay(
      TimeOfDay.fromDateTime(localCreatedAt),
      alwaysUse24HourFormat: general.alwaysUse24HourFormat,
    );

    return FittedBox(
      child: Text(
        '$time \u00b7 $date',
        textDirection: TextDirection.ltr,
        style: theme.textTheme.bodyLarge!
            .copyWith(height: 1)
            .apply(fontSizeDelta: sizeDelta),
      ),
    );
  }
}
