import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class TrendsSelectionRow extends ConsumerWidget {
  const TrendsSelectionRow();

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
                  CupertinoIcons.location,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  userLocation.displayName,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                onTap: () => _showTrendsConfiguration(context, ref.read),
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

void _showTrendsConfiguration(BuildContext context, Reader read) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Text(read(userTrendsLocationProvider).displayName),
      ),
      const TrendsSelectionListTile(),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('find location'),
        onTap: () {
          Navigator.of(context).pop();
          // TODO: implement find location dialog
          // showDialog<void>(
          //   context: context,
          //   builder: (_) => const FindLocationDialog(),
          // );
        },
      ),
    ],
  );
}
