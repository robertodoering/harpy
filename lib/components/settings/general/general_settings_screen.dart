import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen();

  static const route = 'general_settings';

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return HarpyScaffold(
      body: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(
            title: 'general settings',
            floating: true,
          ),
          SliverPadding(
            padding: config.edgeInsets,
            sliver: const _GeneralSettingsList(),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _GeneralSettingsList extends StatefulWidget {
  const _GeneralSettingsList();

  @override
  _GeneralSettingsListState createState() => _GeneralSettingsListState();
}

class _GeneralSettingsListState extends State<_GeneralSettingsList> {
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

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.update),
            title: const Text('show changelog dialog'),
            subtitle: const Text('when the app has been updated'),
            value: changelogPreferences.showChangelogDialog,
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => changelogPreferences.showChangelogDialog = value);
            },
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('automatic crash reports'),
            subtitle: const Text('anonymously report errors to improve harpy'),
            value: generalPreferences.crashReports,
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => generalPreferences.crashReports = value);
            },
          ),
        ),
        verticalSpacer,
        Card(
          child: RadioDialogTile<int>(
            leading: CupertinoIcons.square_list,
            title: 'restore home timeline position on app start',
            titles: _homeTimelinePositionBehavior.values.toList(),
            subtitle: _homeTimelinePositionBehavior[
                generalPreferences.homeTimelinePositionBehavior],
            values: _homeTimelinePositionBehavior.keys.toList(),
            description: 'change how the app behaves when opening the home '
                'timeline',
            value: generalPreferences.homeTimelinePositionBehavior,
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(
                () => generalPreferences.homeTimelinePositionBehavior = value!,
              );
            },
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.speed),
            title: const Text('performance mode'),
            subtitle: const Text('reduces animations and effects'),
            value: generalPreferences.performanceMode,
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => generalPreferences.performanceMode = value);
            },
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(FeatherIcons.feather),
            title: const Text('floating compose button'),
            subtitle: const Text(
              'display a floating compose button in the home screen',
            ),
            value: generalPreferences.floatingComposeButton,
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => generalPreferences.floatingComposeButton = value);
            },
          ),
        ),
        verticalSpacer,
        ExpansionCard(
          title: const Text('home tab bar'),
          children: [
            HarpySwitchTile(
              leading: const Icon(CupertinoIcons.rectangle),
              title: const Text('automatically hide tab bar'),
              subtitle: Text(
                'when scrolling ${config.bottomAppBar ? "up" : "down"}',
              ),
              value: config.hideHomeTabBar,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                configCubit.updateHideHomeTabBar(value);
              },
            ),
            HarpySwitchTile(
              leading: const Icon(CupertinoIcons.rectangle_dock),
              title: const Text('bottom tab bar'),
              subtitle: const Text('position the tab bar at the bottom'),
              value: config.bottomAppBar,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                configCubit.updateBottomAppBar(value);
              },
            ),
          ],
        ),
      ]),
    );
  }
}
