import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// Loading shimmer representing a [TweetListInfoMessage].
class TweetListInfoMessageLoadingShimmer extends ConsumerWidget {
  const TweetListInfoMessageLoadingShimmer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: display.paddingValue * 2,
          vertical: display.smallPaddingValue,
        ),
        child: const InfoRowPlaceholder(),
      ),
    );
  }
}

class InfoRowPlaceholder extends ConsumerWidget {
  const InfoRowPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return Row(
      children: [
        SizedBox(
          width: TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
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
