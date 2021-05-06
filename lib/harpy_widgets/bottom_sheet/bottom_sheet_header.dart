import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A widget intended to be the first child in a harpy bottom sheet.
class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: DefaultEdgeInsets.all(),
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!.copyWith(color: theme.accentColor),
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}
