import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// A loading shimmer for a trends list with placeholder trend cards.
class TrendsListLoadingSliver extends StatelessWidget {
  const TrendsListLoadingSliver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    return SliverBoxLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.paddingValue * 2,
          vertical: config.paddingValue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            15,
            Padding(
              padding: EdgeInsets.only(bottom: config.paddingValue * 2),
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
            children: const [
              PlaceholderBox(widthFactor: .75, height: 15),
              defaultSmallVerticalSpacer,
              PlaceholderBox(widthFactor: .3, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
