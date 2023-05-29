import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// A loading shimmer for a user list with placeholder user cards.
class UserListLoadingSliver extends StatelessWidget {
  const UserListLoadingSliver();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverLoadingShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.base * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.filled(
            25,
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: theme.spacing.base * 2,
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
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
        HorizontalSpacer.normal,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaceholderBox(widthFactor: .75, height: 15),
              VerticalSpacer.small,
              PlaceholderBox(widthFactor: .3, height: 15),
              VerticalSpacer.small,
              PlaceholderBox(widthFactor: 1, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
