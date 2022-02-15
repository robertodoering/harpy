import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class GeneralSettingsPage extends ConsumerWidget {
  const GeneralSettingsPage();

  static const name = 'general_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: 'general'),
          SliverPadding(
            padding: display.edgeInsets,
            sliver: const _GeneralSettingsList(),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _GeneralSettingsList extends ConsumerWidget {
  const _GeneralSettingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final general = ref.watch(generalPreferencesProvider);
    final generalNotifier = ref.watch(generalPreferencesProvider.notifier);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.update),
            title: const Text('show changelog dialog'),
            subtitle: const Text('when the app has been updated'),
            value: general.showChangelogDialog,
            borderRadius: harpyTheme.borderRadius,
            onChanged: generalNotifier.setShowChangelogDialog,
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('automatic crash reports'),
            subtitle: const Text('anonymously report errors to improve harpy'),
            value: general.crashReports,
            borderRadius: harpyTheme.borderRadius,
            onChanged: generalNotifier.setCrashReports,
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpyRadioDialogTile(
            leading: const Icon(CupertinoIcons.square_list),
            title: const Text('restore home timeline position on app start'),
            borderRadius: harpyTheme.borderRadius,
            dialogTitle: const Text(
              'change how the app behaves when opening the home timeline',
            ),
            entries: const {
              0: Text('show newest already-read tweet'),
              1: Text('show last read tweet'),
              2: Text("show newest tweet (don't restore position)"),
            },
            groupValue: general.homeTimelinePositionBehavior,
            onChanged: generalNotifier.setHomeTimelinePositionBehavior,
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(Icons.speed),
            title: const Text('performance mode'),
            subtitle: const Text('reduces animations and effects'),
            value: general.performanceMode,
            borderRadius: harpyTheme.borderRadius,
            onChanged: generalNotifier.setPerformanceMode,
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
            value: general.floatingComposebutton,
            borderRadius: harpyTheme.borderRadius,
            onChanged: generalNotifier.setFloatingComposebutton,
          ),
        ),
        verticalSpacer,
        ExpansionCard(
          title: const Text('home app bar'),
          children: [
            HarpySwitchTile(
              leading: const Icon(CupertinoIcons.rectangle),
              title: const Text('automatically hide app bar'),
              subtitle: Text(
                'when scrolling ${general.bottomAppBar ? "up" : "down"}',
              ),
              value: general.hideHomeAppBar,
              onChanged: generalNotifier.setHideHomeAppbar,
            ),
            HarpySwitchTile(
              leading: const Icon(CupertinoIcons.rectangle_dock),
              title: const Text('bottom app bar'),
              subtitle: const Text('position the app bar at the bottom'),
              value: general.bottomAppBar,
              onChanged: generalNotifier.setBottomAppBar,
            ),
          ],
        ),
      ]),
    );
  }
}
