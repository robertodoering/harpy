import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A loading shimmer for a trends list with placeholder trend cards.
class TrendsListLoadingSliver extends StatelessWidget {
  const TrendsListLoadingSliver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverBoxLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPaddingValue * 2,
          vertical: defaultPaddingValue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            15,
            Padding(
              padding: EdgeInsets.only(bottom: defaultPaddingValue * 2),
              child: const TrendsPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class TrendsPlaceholder extends StatelessWidget {
  const TrendsPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PlaceholderBox(width: 28, height: 28, shape: BoxShape.circle),
        defaultHorizontalSpacer,
        defaultHorizontalSpacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlaceholderBox(widthFactor: .75, height: 15),
              defaultSmallVerticalSpacer,
              const PlaceholderBox(widthFactor: .3, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
