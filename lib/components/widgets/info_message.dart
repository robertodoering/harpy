import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

/// Builds an info message that fades into view.
///
/// Either [primaryMessage] or [secondaryMessage] must not be `null`.
class InfoMessage extends StatelessWidget {
  const InfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  }) : assert(primaryMessage != null || secondaryMessage != null);

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ImmediateOpacityAnimation(
      duration: theme.animation.short,
      child: Container(
        padding: theme.spacing.edgeInsets,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (primaryMessage != null)
              DefaultTextStyle(
                style: theme.textTheme.titleLarge!,
                textAlign: TextAlign.center,
                child: primaryMessage!,
              ),
            if (primaryMessage != null && secondaryMessage != null)
              VerticalSpacer.normal,
            if (secondaryMessage != null)
              DefaultTextStyle(
                style: theme.textTheme.titleSmall!,
                textAlign: TextAlign.center,
                child: secondaryMessage!,
              ),
          ],
        ),
      ),
    );
  }
}
