import 'package:flutter/material.dart';

import '../list_info_message.dart';

/// A message for the center of a [CustomScrollView].
class SliverFillInfoMessage extends StatelessWidget {
  const SliverFillInfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  });

  final Widget primaryMessage;
  final Widget secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ListInfoMessage(
        primaryMessage: primaryMessage,
        secondaryMessage: secondaryMessage,
      ),
    );
  }
}
