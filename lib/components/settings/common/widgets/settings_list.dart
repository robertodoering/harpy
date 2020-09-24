import 'package:flutter/material.dart';
import 'package:harpy/components/settings/common/widgets/settings_group.dart';

/// Builds a [ListView] with [SettingsGroup]s for each entry in [settings].
class SettingsList extends StatelessWidget {
  const SettingsList({
    @required this.settings,
  });

  final Map<String, List<Widget>> settings;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: settings.length,
      itemBuilder: (BuildContext context, int index) => SettingsGroup(
        title: settings.keys.elementAt(index),
        children: settings.values.elementAt(index),
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }
}
