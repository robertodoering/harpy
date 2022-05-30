import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Builds an info message that fades into view.
///
/// Either [primaryMessage] or [secondaryMessage] must not be `null`.
class InfoMessage extends ConsumerWidget {
  const InfoMessage({
    this.primaryMessage,
    this.secondaryMessage,
  }) : assert(primaryMessage != null || secondaryMessage != null);

  final Widget? primaryMessage;
  final Widget? secondaryMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return ImmediateOpacityAnimation(
      duration: kShortAnimationDuration,
      child: Container(
        padding: display.edgeInsets,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (primaryMessage != null)
              DefaultTextStyle(
                style: theme.textTheme.headline6!,
                textAlign: TextAlign.center,
                child: primaryMessage!,
              ),
            if (primaryMessage != null && secondaryMessage != null)
              verticalSpacer,
            if (secondaryMessage != null)
              DefaultTextStyle(
                style: theme.textTheme.subtitle2!,
                textAlign: TextAlign.center,
                child: secondaryMessage!,
              ),
          ],
        ),
      ),
    );
  }
}
