import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class TrendsSelectionHeader extends ConsumerWidget {
  const TrendsSelectionHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final state = ref.watch(trendsProvider);
    final notifier = ref.watch(trendsProvider.notifier);
    final userLocation = ref.watch(userTrendsLocationProvider);

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: HarpyListCard(
                leading: Icon(
                  FeatherIcons.mapPin,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  userLocation.displayName,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                onTap: () => _showTrendsSelection(ref),
              ),
            ),
            horizontalSpacer,
            HarpyButton.card(
              icon: const Icon(CupertinoIcons.refresh),
              onTap: state is AsyncLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      UserScrollDirection.of(context)?.idle();
                      notifier.load();
                    },
            )
          ],
        ),
      ),
    );
  }
}

void _showTrendsSelection(WidgetRef ref) {
  showHarpyBottomSheet<void>(
    ref.context,
    harpyTheme: ref.read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Text(ref.read(userTrendsLocationProvider).displayName),
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.list_bullet),
        title: const Text('select location'),
        subtitle: Text(ref.read(userTrendsLocationProvider).name),
        onTap: () {
          Navigator.of(ref.context).pop();
          HapticFeedback.lightImpact();
          showDialog<void>(
            context: ref.context,
            builder: (_) => const TrendsLocationSelectionDialog(),
          );
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('find location'),
        onTap: () {
          Navigator.of(ref.context).pop();
          HapticFeedback.lightImpact();
          showDialog<void>(
            context: ref.context,
            builder: (_) => const FindTrendsLocationDialog(),
          );
        },
      ),
    ],
  );
}
