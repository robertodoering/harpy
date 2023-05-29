import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// A loading shimmer for a trends list with placeholder trend cards.
class TrendsListLoadingSliver extends StatelessWidget {
  const TrendsListLoadingSliver();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.base * 2,
          vertical: theme.spacing.base,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            25,
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: theme.spacing.base * 2,
              ),
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
    return const Row(
      children: [
        PlaceholderBox(width: 28, height: 28, shape: BoxShape.circle),
        HorizontalSpacer.normal,
        HorizontalSpacer.normal,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaceholderBox(widthFactor: .75, height: 15),
              VerticalSpacer.small,
              PlaceholderBox(widthFactor: .3, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
