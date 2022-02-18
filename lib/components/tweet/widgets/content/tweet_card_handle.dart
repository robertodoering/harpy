import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCardHandle extends ConsumerWidget {
  const TweetCardHandle({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return GestureDetector(
      // TODO: on user tap
      // onTap: () => context.read<TweetBloc>().onUserTap(context),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '@${tweet.user.handle}',
              style: theme.textTheme.bodyText1!
                  .copyWith(height: 1)
                  .apply(fontSizeDelta: style.sizeDelta),
            ),
            TextSpan(
              text: ' \u00b7 ',
              style: theme.textTheme.bodyText1!
                  .copyWith(height: 1)
                  .apply(fontSizeDelta: style.sizeDelta),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: display.absoluteTweetTime
                  ? _CreatedAtAbsoluteTime(
                      createdAt: tweet.createdAt,
                      sizeDelta: style.sizeDelta,
                    )
                  : _CreatedAtRelativeTime(
                      createdAt: tweet.createdAt,
                      sizeDelta: style.sizeDelta,
                    ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _CreatedAtRelativeTime extends StatefulWidget {
  const _CreatedAtRelativeTime({
    required this.createdAt,
    this.sizeDelta = 0,
  });

  final DateTime createdAt;
  final double sizeDelta;

  @override
  _CreatedAtRelativeTimeState createState() => _CreatedAtRelativeTimeState();
}

class _CreatedAtRelativeTimeState extends State<_CreatedAtRelativeTime> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final localCreatedAt = widget.createdAt.toLocal();
    final difference = DateTime.now().difference(localCreatedAt);

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

    return Text(
      _tweetTimeDifference(context, widget.createdAt),
      style: theme.textTheme.bodyText1!
          .copyWith(height: 1)
          .apply(fontSizeDelta: widget.sizeDelta),
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}

class _CreatedAtAbsoluteTime extends StatelessWidget {
  const _CreatedAtAbsoluteTime({
    required this.createdAt,
    this.sizeDelta = 0,
  });

  final DateTime createdAt;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      _getAbsoluteTime(context, createdAt),
      style: theme.textTheme.bodyText1!
          .copyWith(height: 1)
          .apply(fontSizeDelta: sizeDelta),
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}

/// Returns a formatted String displaying the difference of the tweet creation
/// time.
String _tweetTimeDifference(BuildContext context, DateTime createdAt) {
  return timeago.format(
    createdAt.toLocal(),
    locale: Localizations.localeOf(context).languageCode,
  );
}

/// Returns a formatted String displaying the absolute time.
String _getAbsoluteTime(BuildContext context, DateTime createdAt) {
  return DateFormat.yMd(Localizations.localeOf(context).languageCode)
      .add_Hm()
      .format(createdAt.toLocal())
      .toLowerCase();
}
