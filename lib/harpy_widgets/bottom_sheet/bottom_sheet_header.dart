import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// A widget intended to be the first child in a harpy bottom sheet.
class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigBloc>().state;

    return Padding(
      padding: config.edgeInsets,
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!.copyWith(color: theme.accentColor),
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}
