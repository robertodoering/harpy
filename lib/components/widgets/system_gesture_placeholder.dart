import 'package:flutter/material.dart';

/// Places gesture detectors at the horizontal edges to prevent horizontal drag
/// gestures and at vertical edges to prevent vertical drag gestures.
///
/// Used to prevent an overlap of the system gestures and scrolling in
/// underlying horizontal or vertical lists.
class SystemGesturePlaceholder extends StatelessWidget {
  const SystemGesturePlaceholder({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        child,
        Align(
          // ignore: non_directional
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: mediaQuery.systemGestureInsets.left,
            child: GestureDetector(onHorizontalDragStart: (_) {}),
          ),
        ),
        Align(
          // ignore: non_directional
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: mediaQuery.systemGestureInsets.right,
            child: GestureDetector(onHorizontalDragStart: (_) {}),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: SizedBox(
            height: mediaQuery.systemGestureInsets.top,
            child: GestureDetector(
              onHorizontalDragStart: (_) {},
              onVerticalDragStart: (_) {},
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: SizedBox(
            height: mediaQuery.systemGestureInsets.bottom,
            child: GestureDetector(
              onHorizontalDragStart: (_) {},
              onVerticalDragStart: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
