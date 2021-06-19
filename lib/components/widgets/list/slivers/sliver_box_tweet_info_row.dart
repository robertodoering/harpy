import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [TweetListInfoRow] in a sliver box adapter.
class SliverBoxTweetListInfoRow extends StatelessWidget {
  const SliverBoxTweetListInfoRow({
    required this.icon,
    required this.text,
    this.padding,
  });

  final Widget icon;
  final Widget text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TweetListInfoRow(
        icon: icon,
        text: text,
        padding: padding,
      ),
    );
  }
}
