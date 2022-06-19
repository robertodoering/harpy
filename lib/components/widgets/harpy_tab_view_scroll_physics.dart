import 'package:flutter/widgets.dart';
import 'package:harpy/components/components.dart';

/// Prevents the start of a scroll motion by increasing the
/// [dragStartDistanceMotionThreshold] based on the [viewportWidth].
///
/// This is used as the scroll physics for the horizontally scrolled
/// [HomeTabView] and [UserTabView] to make vertical scrolling easier in the
/// nested scrollables of the tab view.
class HarpyTabViewScrollPhysics extends ScrollPhysics {
  const HarpyTabViewScrollPhysics({
    required this.viewportWidth,
    super.parent,
  });

  final double viewportWidth;

  @override
  HarpyTabViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HarpyTabViewScrollPhysics(
      viewportWidth: viewportWidth,
      parent: buildParent(ancestor),
    );
  }

  @override
  double? get dragStartDistanceMotionThreshold => viewportWidth * .1;
}
