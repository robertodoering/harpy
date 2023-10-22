import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class HomeTabIconDialog extends StatelessWidget {
  const HomeTabIconDialog({
    required this.entry,
  });

  final HomeTabEntry entry;

  @override
  Widget build(BuildContext context) {
    return RbyDialog(
      title: Text(entry.name.isNotEmpty ? '${entry.name} icon' : 'icon'),
      content: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          if (entry.name.isNotEmpty) _IconButton(iconName: entry.name[0]),
          for (final String iconName in HomeTabEntryIcon.iconNameMap.keys)
            _IconButton(iconName: iconName),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.iconName,
  });

  final String iconName;

  @override
  Widget build(BuildContext context) {
    return RbyButton.transparent(
      icon: HomeTabEntryIcon(iconName),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop(iconName);
      },
    );
  }
}
