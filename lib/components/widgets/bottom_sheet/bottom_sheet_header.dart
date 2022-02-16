import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class BottomSheetHeader extends ConsumerWidget {
  const BottomSheetHeader({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: display.edgeInsets,
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!.copyWith(
          color: theme.colorScheme.primary,
        ),
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}
