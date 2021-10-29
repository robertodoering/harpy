import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A [HarpyListCard] that is styled for content in the setup screen.
class SetupListCard extends StatelessWidget {
  const SetupListCard({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyListCard(
      title: Center(
        child: Text(
          text,
          style: selected
              ? theme.textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                )
              : theme.textTheme.headline5,
        ),
      ),
      border: selected ? Border.all(color: theme.colorScheme.primary) : null,
      onTap: onTap,
    );
  }
}
