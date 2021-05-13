import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A message for the beginning or end of a [CustomScrollView].
class SliverBoxInfoMessage extends StatelessWidget {
  const SliverBoxInfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  });

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListInfoMessage(
        primaryMessage: primaryMessage,
        secondaryMessage: secondaryMessage,
      ),
    );
  }
}
