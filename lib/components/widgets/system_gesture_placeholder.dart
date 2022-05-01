import 'package:flutter/material.dart';

/// Places gesture detectors at the horizontal edges to prevent horizontal drag
/// gestures and at the bottom to prevent vertical drag gestures.
///
/// Used to prevent an overlap of the Android system gestures and scrolling in
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
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: mediaQuery.size.width * .066,
            child: GestureDetector(onHorizontalDragStart: (_) {}),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: mediaQuery.size.width * .066,
            child: GestureDetector(onHorizontalDragStart: (_) {}),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: mediaQuery.size.height * .044,
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
