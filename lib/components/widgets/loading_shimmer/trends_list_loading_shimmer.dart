import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// A loading shimmer for a trends list with placeholder trend cards.
class TrendsListLoadingSliver extends ConsumerWidget {
  const TrendsListLoadingSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: display.paddingValue * 2,
          vertical: display.paddingValue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            25,
            Padding(
              padding: EdgeInsets.only(bottom: display.paddingValue * 2),
              child: const TrendsPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class TrendsPlaceholder extends StatelessWidget {
  const TrendsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PlaceholderBox(width: 28, height: 28, shape: BoxShape.circle),
        horizontalSpacer,
        horizontalSpacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PlaceholderBox(widthFactor: .75, height: 15),
              smallVerticalSpacer,
              PlaceholderBox(widthFactor: .3, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
