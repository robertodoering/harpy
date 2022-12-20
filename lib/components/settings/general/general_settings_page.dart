import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class GeneralSettingsPage extends ConsumerWidget {
  const GeneralSettingsPage();

  static const name = 'general_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('general'),
            actions: [
              RbyPopupMenuButton(
                onSelected: (_) => ref
                    .read(generalPreferencesProvider.notifier)
                    .defaultSettings(),
                itemBuilder: (_) => const [
                  RbyPopupMenuListTile(
                    value: true,
                    title: Text('reset to default'),
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
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
    final theme = Theme.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final generalNotifier = ref.watch(generalPreferencesProvider.notifier);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: RbySwitchTile(
            leading: const Icon(Icons.update),
            title: const Text('show changelog dialog'),
            subtitle: const Text('when the app has been updated'),
            value: general.showChangelogDialog,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setShowChangelogDialog,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('automatic crash reports'),
            subtitle: const Text('anonymously report errors to improve harpy'),
            value: general.crashReports,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setCrashReports,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(Icons.speed),
            title: const Text('performance mode'),
            subtitle: const Text('reduces animations and effects'),
            value: general.performanceMode,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setPerformanceMode,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(Icons.access_time),
            title: const Text('always use 24-hour time format'),
            value: general.alwaysUse24HourFormat,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setAlwaysUse24HourFormat,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(FeatherIcons.feather),
            title: const Text('floating compose button'),
            subtitle: const Text(
              'display a floating compose button in the home screen',
            ),
            value: general.floatingComposeButton,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setFloatingComposeButton,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: HarpyRadioDialogTile(
            leading: const Icon(CupertinoIcons.square_list),
            title: const Text('restore home timeline position on app start'),
            dialogTitle: const Text(
              'change how the app behaves when opening the home timeline',
            ),
            entries: const {
              0: Text('show newest already-read tweet'),
              1: Text('show last read tweet'),
              2: Text("show newest tweet (don't restore position)"),
            },
            groupValue: general.homeTimelinePositionBehavior,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setHomeTimelinePositionBehavior,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.refresh),
            title: const Text('restore home timeline position on refresh'),
            subtitle: const Text(
              'restores your position in the home timeline after a refresh',
            ),
            value: general.homeTimelineRefreshBehavior,
            borderRadius: theme.shape.borderRadius,
            onChanged: generalNotifier.setHomeTimelineRefreshBehavior,
          ),
        ),
        VerticalSpacer.normal,
        ExpansionCard(
          title: const Text('home app bar'),
          children: [
            RbySwitchTile(
              leading: const Icon(CupertinoIcons.rectangle),
              title: const Text('automatically hide app bar'),
              subtitle: const Text('when scrolling down'),
              value: general.hideHomeAppBar,
              onChanged: generalNotifier.setHideHomeAppbar,
            ),
            RbySwitchTile(
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
