import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

/// A [RbyListCard] that is styled for content in the setup screen.
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

    return RbyListCard(
      title: Center(
        child: Text(
          text,
          style: selected
              ? theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                )
              : theme.textTheme.headlineSmall,
        ),
      ),
      border: selected ? Border.all(color: theme.colorScheme.primary) : null,
      onTap: onTap,
    );
  }
}
