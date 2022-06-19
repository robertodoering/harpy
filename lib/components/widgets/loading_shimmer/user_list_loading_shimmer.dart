import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// A loading shimmer for a user list with placeholder user cards.
class UserListLoadingSliver extends ConsumerWidget {
  const UserListLoadingSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: display.paddingValue * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            25,
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: display.paddingValue * 2,
              ),
              child: const UserPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserPlaceholder extends StatelessWidget {
  const UserPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
        horizontalSpacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PlaceholderBox(widthFactor: .75, height: 15),
              smallVerticalSpacer,
              PlaceholderBox(widthFactor: .3, height: 15),
              smallVerticalSpacer,
              PlaceholderBox(widthFactor: 1, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
