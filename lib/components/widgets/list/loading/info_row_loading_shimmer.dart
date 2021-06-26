import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Loading shimmer representing a [TweetListInfoRow].
class InfoRowLoadingShimmer extends StatelessWidget {
  const InfoRowLoadingShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverBoxLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPaddingValue * 2,
          vertical: defaultSmallPaddingValue,
        ),
        child: const InfoRowPlaceholder(),
      ),
    );
  }
}

class InfoRowPlaceholder extends StatelessWidget {
  const InfoRowPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: TweetCardAvatar.defaultRadius * 2,
          child: const PlaceholderBox(
              width: 28, height: 28, shape: BoxShape.circle),
        ),
        defaultHorizontalSpacer,
        const Expanded(
          child: PlaceholderBox(
            widthFactor: .3,
            height: 15,
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }
}
