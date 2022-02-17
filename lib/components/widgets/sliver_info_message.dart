import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class SliverInfoMessage extends StatelessWidget {
  const SliverInfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  }) : assert(primaryMessage != null || secondaryMessage != null);

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return InfoMessage(
      primaryMessage: primaryMessage,
      secondaryMessage: secondaryMessage,
    );
  }
}
