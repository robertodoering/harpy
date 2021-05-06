import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds a [ListView] with [SettingsGroup]s for each entry in [settings].
class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.settings,
  });

  final Map<String, List<Widget>> settings;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: settings.length,
      itemBuilder: (_, index) => SettingsGroup(
        title: settings.keys.elementAt(index),
        children: settings.values.elementAt(index),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }
}
