import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class TrendsSelection extends ConsumerWidget {
  const TrendsSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final state = ref.watch(trendsProvider);
    final notifier = ref.watch(trendsProvider.notifier);
    final location = ref.watch(customTrendsLocationProvider);

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
                  location.displayName,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                // TODO: imeplement trends configuration
                // onTap: () => _showTrendsConfiguration(context),
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
