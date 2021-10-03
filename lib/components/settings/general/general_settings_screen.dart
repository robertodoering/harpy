import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen();

  static const String route = 'general_settings';

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final changelogPreferences = app<ChangelogPreferences>();
    final generalPreferences = app<GeneralPreferences>();

    final configCubit = context.watch<ConfigCubit>();
    final config = configCubit.state;

    return HarpyScaffold(
      title: 'general',
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HarpySwitchTile(
            leading: const Icon(Icons.update),
            title: const Text('show changelog dialog'),
            subtitle: const Text('when the app has been updated'),
            value: changelogPreferences.showChangelogDialog,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => changelogPreferences.showChangelogDialog = value);
            },
          ),
          HarpySwitchTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('automatic crash reports'),
            subtitle: const Text('anonymously report errors to improve harpy'),
            value: generalPreferences.crashReports,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => generalPreferences.crashReports = value);
            },
          ),
          HarpySwitchTile(
            leading: const Icon(Icons.speed),
            title: const Text('performance mode'),
            subtitle: const Text('reduces animations and effects'),
            value: generalPreferences.performanceMode,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => generalPreferences.performanceMode = value);
            },
          ),
          HarpySwitchTile(
            leading: const Icon(CupertinoIcons.rectangle_dock),
            title: const Text('bottom app bar'),
            subtitle: const Text('position the home app bar at the bottom'),
            value: config.bottomAppBar,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              configCubit.updateBottomAppBar(value);
            },
          ),
        ],
      ),
    );
  }
}
