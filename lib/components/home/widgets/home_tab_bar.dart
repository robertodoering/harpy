import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

class HomeTabBar extends ConsumerWidget {
  const HomeTabBar({
    required this.padding,
  });

  final EdgeInsets padding;

  Widget _mapEntryTabs({
    required HomeTabEntry entry,
    required Color cardColor,
    required EdgeInsets padding,
  }) {
    if (entry.type == HomeTabEntryType.defaultType && entry.id == 'mentions') {
      return _MentionsTab(entry: entry);
    } else {
      return HarpyTab(
        icon: HomeTabEntryIcon(entry.icon),
        text: entry.hasName ? Text(entry.name!) : null,
        cardColor: cardColor,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final configuration = ref.watch(homeTabConfigurationProvider);

    return HarpyTabBar(
      padding: padding,
      tabs: [
        const _DrawerTab(),
        for (final entry in configuration.visibleEntries)
          _mapEntryTabs(
            entry: entry,
            cardColor: harpyTheme.colors.alternateCardColor,
            padding: padding,
          ),
      ],
      endWidgets: const [_CustomizeHomeTab()],
    );
  }
}

class _DrawerTab extends ConsumerWidget {
  const _DrawerTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return HarpyTab(
      cardColor: harpyTheme.colors.alternateCardColor,
      selectedCardColor: theme.colorScheme.primary,
      selectedForegroundColor: theme.colorScheme.onPrimary,
      icon: const RotatedBox(
        quarterTurns: 1,
        child: Icon(FeatherIcons.barChart2),
      ),
    );
  }
}

class _MentionsTab extends ConsumerWidget {
  const _MentionsTab({
    required this.entry,
  });

  final HomeTabEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    final child = HarpyTab(
      icon: HomeTabEntryIcon(entry.icon),
      text: entry.hasName ? Text(entry.name!) : null,
      cardColor: harpyTheme.colors.alternateCardColor,
    );

    return Badge(
      // TODO: show only when new mentions
      // show: true,
      child: child,
    );
  }
}

class _CustomizeHomeTab extends StatelessWidget {
  const _CustomizeHomeTab();

  @override
  Widget build(BuildContext context) {
    // final child = HarpyButton.flat(
    //   padding: EdgeInsets.all(HarpyTab.tabPadding(context)),
    //   icon: const Icon(FeatherIcons.settings),
    //   onTap: () => app<HarpyNavigator>().pushHomeTabCustomizationScreen(
    //     model: context.read<HomeTabModel>(),
    //   ),
    // );

    // TODO: implement home customization tab
    return const SizedBox();

    // if (isFree) {
    //   return Bubbled(
    //     bubble: const FlareIcon.shiningStar(),
    //     bubbleOffset: const Offset(2, -2),
    //     child: child,
    //   );
    // } else {
    //   return child;
    // }
  }
}
