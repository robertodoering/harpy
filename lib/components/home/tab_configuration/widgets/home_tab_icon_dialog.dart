import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';

class HomeTabIconDialog extends StatelessWidget {
  const HomeTabIconDialog({
    required this.entry,
  });

  final HomeTabEntry entry;

  @override
  Widget build(BuildContext context) {
    final String title;

    if (entry.name != null && entry.name!.isNotEmpty) {
      title = '${entry.name} icon';
    } else {
      title = 'icon';
    }

    return HarpyDialog(
      title: Text(title),
      content: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          if (entry.hasName) _IconButton(iconName: entry.name![0]),
          for (String iconName in HomeTabEntryIcon.iconNameMap.keys)
            _IconButton(iconName: iconName)
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
    return HarpyButton.icon(
      icon: HomeTabEntryIcon(iconName),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop(iconName);
      },
    );
  }
}
