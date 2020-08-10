import 'package:flutter/material.dart';
import 'package:harpy/components/settings/widgets/common/settings_group.dart';

/// Builds a [ListView] with [SettingsGroup]s for each entry in [settings].
class SettingsList extends StatelessWidget {
  const SettingsList({
    @required this.settings,
  });

  final Map<String, List<Widget>> settings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: settings.entries.map((MapEntry<String, List<Widget>> entry) {
        return SettingsGroup(
          title: entry.key,
          children: entry.value,
        );
      }).toList(),
    );
  }
}
