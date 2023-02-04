import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeTabBar extends ConsumerWidget {
  const HomeTabBar({
    required this.padding,
  });

  final EdgeInsetsGeometry padding;

  Widget _mapEntryTabs({
    required HomeTabEntry entry,
    required Color cardColor,
    required EdgeInsetsGeometry padding,
  }) {
    return entry.type == HomeTabEntryType.defaultType && entry.id == 'mentions'
        ? _MentionsTab(entry: entry)
        : HarpyTab(
            icon: HomeTabEntryIcon(entry.icon),
            text: entry.name.isNotEmpty ? Text(entry.name) : null,
            cardColor: cardColor,
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final configuration = ref.watch(homeTabConfigurationProvider);

    return HarpyTabBar(
      controller: HomeTabController.of(context),
      padding: padding,
      tabs: [
        const _HomeDrawerTab(),
        for (final entry in configuration.visibleEntries)
          _mapEntryTabs(
            entry: entry,
            cardColor: harpyTheme.colors.alternateCardColor,
            padding: padding,
          ),
        const _HomeCustomizationTab(),
      ],
    );
  }
}

class _HomeDrawerTab extends ConsumerWidget {
  const _HomeDrawerTab();

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
    final state = ref.watch(mentionsTimelineProvider);

    final child = HarpyTab(
      icon: HomeTabEntryIcon(entry.icon),
      text: entry.name.isNotEmpty ? Text(entry.name) : null,
      cardColor: harpyTheme.colors.alternateCardColor,
    );

    return HarpyBadge(
      show: state.hasNewMentions,
      child: child,
    );
  }
}

class _HomeCustomizationTab extends ConsumerWidget {
  const _HomeCustomizationTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    return HarpyBadge.custom(
      // analyzer false positive
      // ignore: avoid_redundant_argument_values
      show: isFree,
      badge: FlareIcon.shiningStar(iconSize: iconTheme.size! - 4),
      child: const HarpyTab(
        icon: Icon(Icons.settings_rounded),
        cardColor: Colors.transparent,
      ),
    );
  }
}
