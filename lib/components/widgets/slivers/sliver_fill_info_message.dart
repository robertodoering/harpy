import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class SliverFillInfoMessage extends StatelessWidget {
  const SliverFillInfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  }) : assert(primaryMessage != null || secondaryMessage != null);

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: InfoMessage(
        primaryMessage: primaryMessage,
        secondaryMessage: secondaryMessage,
      ),
    );
  }
}
