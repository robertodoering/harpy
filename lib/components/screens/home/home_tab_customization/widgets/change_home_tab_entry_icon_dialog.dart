import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class ChangeHomeTabEntryIconDialog extends StatelessWidget {
  const ChangeHomeTabEntryIconDialog({
    required this.entry,
  });

  final HomeTabEntry entry;

  Widget _buildButton(BuildContext context, String iconName) {
    if (iconName == entry.icon) {
      return HarpyButton.raised(
        padding: const EdgeInsets.all(8),
        icon: HomeTabEntryIcon(iconName),
        onTap: () => Navigator.of(context).pop(),
      );
    } else {
      return HarpyButton.flat(
        padding: const EdgeInsets.all(8),
        icon: HomeTabEntryIcon(iconName),
        onTap: () => Navigator.of(context).pop<String>(iconName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: Text('${entry.name} icon'),
      content: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          if (entry.hasName) _buildButton(context, entry.name![0]),
          for (String iconName in HomeTabEntryIcon.iconNameMap.keys)
            _buildButton(context, iconName)
        ],
      ),
    );
  }
}
