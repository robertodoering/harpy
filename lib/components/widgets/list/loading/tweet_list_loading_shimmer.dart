import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// A loading shimmer for a tweet list with placeholder tweet cards.
class TweetListLoadingSliver extends StatelessWidget {
  const TweetListLoadingSliver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverBoxLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.paddingValue * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            5,
            Padding(
              padding: EdgeInsets.only(bottom: config.paddingValue * 2),
              child: const TweetPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class TweetPlaceholder extends StatelessWidget {
  const TweetPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
            defaultHorizontalSpacer,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PlaceholderBox(widthFactor: .75, height: 15),
                  defaultSmallVerticalSpacer,
                  PlaceholderBox(widthFactor: .5, height: 15),
                ],
              ),
            )
          ],
        ),
        defaultVerticalSpacer,
        const PlaceholderBox(widthFactor: .6, height: 15),
        defaultSmallVerticalSpacer,
        const PlaceholderBox(height: 15),
        defaultSmallVerticalSpacer,
        const PlaceholderBox(widthFactor: .8, height: 15),
      ],
    );
  }
}
