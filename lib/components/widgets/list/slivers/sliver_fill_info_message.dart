import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A message for the center of a [CustomScrollView].
class SliverFillInfoMessage extends StatelessWidget {
  const SliverFillInfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  });

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ListInfoMessage(
        primaryMessage: primaryMessage,
        secondaryMessage: secondaryMessage,
      ),
    );
  }
}
