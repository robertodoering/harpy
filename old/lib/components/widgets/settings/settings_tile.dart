import 'package:flutter/material.dart';

/// Builds a [ListTile] with a [DropdownButton] that contains
/// [DropdownMenuItem]s for each entry in [items] with [value] being the index
/// of the item in the list.
class DropdownSettingsTile extends StatelessWidget {
  const DropdownSettingsTile({
    @required this.title,
    @required this.value,
    @required this.items,
    @required this.onChanged,
    this.leading,
    this.enabled = true,
  });

  final String title;
  final int value;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final IconData leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      leading: Icon(leading),
      title: Text(title),
      trailing: DropdownButton<int>(
        value: value,
        items: items.asMap().entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        disabledHint: Text(items[value]),
      ),
    );
  }
}
