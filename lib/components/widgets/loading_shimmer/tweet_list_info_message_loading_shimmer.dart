import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Loading shimmer representing a [TweetListInfoMessage].
class TweetListInfoMessageLoadingShimmer extends StatelessWidget {
  const TweetListInfoMessageLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.base * 2,
          vertical: theme.spacing.small,
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
        HorizontalSpacer.normal,
        const Expanded(
          child: PlaceholderBox(
            widthFactor: .3,
            height: 15,
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
      ],
    );
  }
}
