import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// A loading shimmer for a tweet list with placeholder tweet cards.
class TweetListLoadingSliver extends ConsumerWidget {
  const TweetListLoadingSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverLoadingShimmer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacer,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: display.paddingValue * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.filled(
                  15,
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      bottom: display.paddingValue * 2,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
            horizontalSpacer,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PlaceholderBox(widthFactor: .75, height: 15),
                  smallVerticalSpacer,
                  PlaceholderBox(widthFactor: .5, height: 15),
                ],
              ),
            )
          ],
        ),
        verticalSpacer,
        const PlaceholderBox(widthFactor: .6, height: 15),
        smallVerticalSpacer,
        const PlaceholderBox(height: 15),
        smallVerticalSpacer,
        const PlaceholderBox(widthFactor: .8, height: 15),
      ],
    );
  }
}
