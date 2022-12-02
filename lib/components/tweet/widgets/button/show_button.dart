import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ShowButton extends ConsumerWidget {
  const ShowButton({
    required this.tweet,
    required this.onShow,
    this.sizeDelta = 0,
    this.foregroundColor,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onShow;
  final double sizeDelta;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => const Text('show'),
      foregroundColor: foregroundColor,
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activate: () => onShow?.call(ref),
      deactivate: null,
    );
  }
}
