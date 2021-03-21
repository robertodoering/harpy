import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Builds a button linking to the pro version of Harpy.
class BuyProText extends StatelessWidget {
  const BuyProText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: Center(
        child: HarpyButton.flat(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const FlareIcon.shiningStar(size: 32),
          text: const Text('buy harpy pro'),
          // todo: link to harpy pro
          // todo: analytics
          onTap: () => app<MessageService>().show('coming soon!'),
        ),
      ),
    );
  }
}
