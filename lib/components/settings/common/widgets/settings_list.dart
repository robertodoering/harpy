import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds a [ListView] with [SettingsGroup]s for each entry in [settings].
class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.settings,
  });

  final Map<String, List<Widget>> settings;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return ListView.separated(
      padding: config.edgeInsetsSymmetric(vertical: true),
      itemCount: settings.length,
      itemBuilder: (_, index) => SettingsGroup(
        title: settings.keys.elementAt(index),
        children: settings.values.elementAt(index),
      ),
      separatorBuilder: (_, __) => defaultVerticalSpacer,
    );
  }
}
