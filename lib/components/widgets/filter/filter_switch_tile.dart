import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

// FIXME: refactor

class FilterSwitchTile extends StatelessWidget {
  const FilterSwitchTile({
    required this.text,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SwitchListTile(
      value: value,
      contentPadding: EdgeInsetsDirectional.only(
        start: theme.spacing.base,
        // - 8 since the check box icon has a padding of 8
        end: max(theme.spacing.base - 8, 0),
      ),
      title: Text(
        text,
        style: theme.textTheme.titleMedium!.copyWith(
          fontSize: 14,
          color: enabled ? null : theme.disabledColor,
        ),
      ),
      onChanged: enabled ? onChanged : null,
    );
  }
}
