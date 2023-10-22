import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// A loading shimmer for a tweet list with placeholder tweet cards.
class TweetListLoadingSliver extends StatelessWidget {
  const TweetListLoadingSliver();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverLoadingShimmer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer.normal,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.base * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.filled(
                  15,
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      bottom: theme.spacing.base * 2,
                    ),
                    child: const TweetPlaceholder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TweetPlaceholder extends StatelessWidget {
  const TweetPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
            HorizontalSpacer.normal,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlaceholderBox(widthFactor: .75, height: 15),
                  VerticalSpacer.small,
                  PlaceholderBox(widthFactor: .5, height: 15),
                ],
              ),
            ),
          ],
        ),
        VerticalSpacer.normal,
        PlaceholderBox(widthFactor: .6, height: 15),
        VerticalSpacer.small,
        PlaceholderBox(height: 15),
        VerticalSpacer.small,
        PlaceholderBox(widthFactor: .8, height: 15),
      ],
    );
  }
}
