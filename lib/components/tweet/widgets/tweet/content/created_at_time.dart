import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/misc/utils/string_utils.dart';

/// Builds a formatted creation time text that updates automatically when the
/// time changes.
///
/// Used by the [TweetAuthorRow].
class CreatedAtTime extends StatefulWidget {
  const CreatedAtTime({
    @required this.createdAt,
    this.fontSizeDelta = 0,
  });

  final DateTime createdAt;
  final double fontSizeDelta;

  @override
  _CreatedAtTimeState createState() => _CreatedAtTimeState();
}

class _CreatedAtTimeState extends State<CreatedAtTime> {
  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    final DateTime localCreatedAt = widget.createdAt.toLocal();
    final Duration difference = DateTime.now().difference(localCreatedAt);

    if (difference < const Duration(hours: 1)) {
      // update every minute
      Timer(const Duration(minutes: 1), _rebuild);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      '${tweetTimeDifference(widget.createdAt)}',
      style: theme.textTheme.bodyText1.apply(
        fontSizeDelta: widget.fontSizeDelta,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
