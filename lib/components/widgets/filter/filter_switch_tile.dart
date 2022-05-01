import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

// FIXME: refactor

class FilterSwitchTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return SwitchListTile(
      value: value,
      contentPadding: EdgeInsets.only(
        left: display.paddingValue,
        // - 8 since the check box icon has a padding of 8
        right: max(display.paddingValue - 8, 0),
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
