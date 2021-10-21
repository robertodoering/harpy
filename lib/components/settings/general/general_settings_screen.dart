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
  final Map<int, String> _homeTimelinePositionBehavior = {
    0: 'show newest already-read tweet',
    1: 'show last read tweet',
    2: "show newest tweet (don't restore position)",
  };

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
          RadioDialogTile<int>(
            leading: CupertinoIcons.square_list,
            title: 'restore home timeline position',
            titles: _homeTimelinePositionBehavior.values.toList(),
            subtitle: _homeTimelinePositionBehavior[
                generalPreferences.homeTimelinePositionBehavior],
            values: _homeTimelinePositionBehavior.keys.toList(),
            description: 'change how the app behaves when opening the home '
                'timeline',
            value: generalPreferences.homeTimelinePositionBehavior,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(
                () => generalPreferences.homeTimelinePositionBehavior = value!,
              );
            },
          ),
          HarpySwitchTile(
            leading: const Icon(CupertinoIcons.rectangle),
            title: const Text('automatically hide tab bar'),
            subtitle: Text(
              'when scrolling ${config.bottomAppBar ? "up" : "down"}',
            ),
            value: generalPreferences.hideHomeTabBar,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(
                () => generalPreferences.hideHomeTabBar = value,
              );
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
