import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a formatted creation time text that updates automatically when the
/// time changes.
///
/// Used by the tweet author row.
class CreatedAtTime extends StatefulWidget {
  const CreatedAtTime({
    required this.createdAt,
    this.fontSizeDelta = 0,
  });

  final DateTime? createdAt;
  final double fontSizeDelta;

  @override
  _CreatedAtTimeState createState() => _CreatedAtTimeState();
}

class _CreatedAtTimeState extends State<CreatedAtTime> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final DateTime localCreatedAt = widget.createdAt!.toLocal();
    final Duration difference = DateTime.now().difference(localCreatedAt);

    if (difference < const Duration(hours: 1)) {
      // update every minute
      _timer = Timer.periodic(const Duration(minutes: 1), _rebuild);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _rebuild(Timer timer) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      tweetTimeDifference(context, widget.createdAt!),
      style: theme.textTheme.bodyText1!.apply(
        fontSizeDelta: widget.fontSizeDelta,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
