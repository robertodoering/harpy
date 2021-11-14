import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Loading shimmer representing a [TweetListInfoRow].
class InfoRowLoadingShimmer extends StatelessWidget {
  const InfoRowLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverBoxLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.paddingValue * 2,
          vertical: config.smallPaddingValue,
        ),
        child: const InfoRowPlaceholder(),
      ),
    );
  }
}

class InfoRowPlaceholder extends StatelessWidget {
  const InfoRowPlaceholder();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return Row(
      children: [
        SizedBox(
          width: TweetCardAvatar.defaultRadius(config.fontSizeDelta) * 2,
          child: const PlaceholderBox(
            width: 28,
            height: 28,
            shape: BoxShape.circle,
          ),
        ),
        horizontalSpacer,
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
