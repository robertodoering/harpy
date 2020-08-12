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
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        for (MapEntry<String, List<Widget>> entry in settings.entries)
          SettingsGroup(
            title: entry.key,
            children: entry.value,
          ),
      ],
    );
  }
}
