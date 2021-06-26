import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class TweetCardHandle extends StatelessWidget {
  const TweetCardHandle({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final fontSizeDelta =
        app<LayoutPreferences>().fontSizeDelta + style.sizeDelta;

    return GestureDetector(
      onTap: () => context.read<TweetBloc>().onUserTap(context),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '@${tweet.user.handle}',
              style: theme.textTheme.bodyText1!
                  .copyWith(height: 1)
                  .apply(fontSizeDelta: fontSizeDelta),
            ),
            TextSpan(
              text: ' \u00b7 ',
              style: theme.textTheme.bodyText1!
                  .copyWith(height: 1)
                  .apply(fontSizeDelta: fontSizeDelta),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: _CreatedAtTime(
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

class _CreatedAtTime extends StatefulWidget {
  const _CreatedAtTime({
    required this.createdAt,
    this.sizeDelta = 0,
  });

  final DateTime createdAt;
  final double sizeDelta;

  @override
  _CreatedAtTimeState createState() => _CreatedAtTimeState();
}

class _CreatedAtTimeState extends State<_CreatedAtTime> {
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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return Text(
      tweetTimeDifference(context, widget.createdAt),
      style: theme.textTheme.bodyText1!
          .copyWith(height: 1)
          .apply(fontSizeDelta: fontSizeDelta + widget.sizeDelta),
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}
