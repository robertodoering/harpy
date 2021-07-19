import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// A loading shimmer for a user list with placeholder user cards.
class UserListLoadingSliver extends StatelessWidget {
  const UserListLoadingSliver({
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
            15,
            Padding(
              padding: EdgeInsets.only(bottom: config.paddingValue * 2),
              child: const UserPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserPlaceholder extends StatelessWidget {
  const UserPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PlaceholderBox(width: 42, height: 42, shape: BoxShape.circle),
        defaultHorizontalSpacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PlaceholderBox(widthFactor: .75, height: 15),
              defaultSmallVerticalSpacer,
              PlaceholderBox(widthFactor: .3, height: 15),
              defaultSmallVerticalSpacer,
              PlaceholderBox(widthFactor: 1, height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
