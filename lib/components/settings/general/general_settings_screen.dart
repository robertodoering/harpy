import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen();

  static const String route = 'general_settings';

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final ChangelogPreferences? changelogPreferences =
      app<ChangelogPreferences>();
  final GeneralPreferences? generalPreferences = app<GeneralPreferences>();

  List<Widget> get _settings {
    return [
      HarpySwitchTile(
        leading: const Icon(Icons.update),
        title: const Text('show changelog dialog'),
        subtitle: const Text('when the app has been updated'),
        value: changelogPreferences!.showChangelogDialog,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          setState(() => changelogPreferences!.showChangelogDialog = value);
        },
      ),
      HarpySwitchTile(
        leading: const Icon(Icons.speed),
        title: const Text('performance mode'),
        subtitle: const Text('reduces animations and effects'),
        value: generalPreferences!.performanceMode,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          setState(() => generalPreferences!.performanceMode = value);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'general',
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
