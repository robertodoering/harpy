import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';
import 'package:sliver_tools/sliver_tools.dart';

class UserPageAvatar extends StatefulWidget {
  const UserPageAvatar({
    required this.url,
  });

  final String url;

  static const double maxAvatarRadius = 48;
  static const double minAvatarRadius = 36;

  @override
  State<UserPageAvatar> createState() => _UserPageAvatar();
}

class _UserPageAvatar extends State<UserPageAvatar> {
  ScrollController? _controller;

  final _radiusNotifier = ValueNotifier(UserPageAvatar.maxAvatarRadius);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= PrimaryScrollController.maybeOf(context)
      ?..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _radiusNotifier.dispose();

    super.dispose();
  }

  void _scrollListener() {
    final theme = Theme.of(context);

    final maxExtent =
        -UserPageAvatar.minAvatarRadius * 2 - theme.spacing.base * 2;

    // interpolate from min radius to max radius when scrolling from 0 to
    // maxExtent
    _radiusNotifier.value = lerpDouble(
      UserPageAvatar.maxAvatarRadius,
      UserPageAvatar.minAvatarRadius,
      (_controller!.offset / (maxExtent.abs() - UserPageAvatar.maxAvatarRadius))
          .clamp(0, 1),
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPositioned(
      bottom: -UserPageAvatar.maxAvatarRadius,
      left: theme.spacing.base * 2,
      child: GestureDetector(
        // prevent opening the banner when tapping on the avatar
        onTap: () {},
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _radiusNotifier,
              builder: (_, __) => HarpyCircleAvatar(
                radius: _radiusNotifier.value,
                imageUrl: widget.url,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
