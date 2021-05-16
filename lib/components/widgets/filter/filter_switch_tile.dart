import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

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
      contentPadding: EdgeInsets.only(
        left: defaultPaddingValue,
        // - 8 since the check box icon has a padding of 8
        right: max(defaultPaddingValue - 8, 0),
      ),
      title: Text(
        text,
        style: theme.textTheme.subtitle1!.copyWith(
          fontSize: 14,
          color: enabled ? null : theme.disabledColor,
        ),
      ),
      onChanged: enabled ? onChanged : null,
    );
  }
}
