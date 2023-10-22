import 'package:flutter/material.dart';

class HarpyBadge extends StatelessWidget {
  const HarpyBadge({
    required this.child,
    this.offset = Offset.zero,
    this.alignment = AlignmentDirectional.topStart,
    this.show = true,
  }) : badge = const _Bubble();

  const HarpyBadge.custom({
    required this.child,
    required this.badge,
    this.offset = Offset.zero,
    this.alignment = AlignmentDirectional.topEnd,
    this.show = true,
  });

  final Widget child;
  final Widget? badge;
  final Offset offset;
  final AlignmentGeometry alignment;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        child,
        if (show)
          Transform.translate(
            offset: offset,
            child: IgnorePointer(child: badge),
          ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
