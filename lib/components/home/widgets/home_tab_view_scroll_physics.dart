import 'package:flutter/widgets.dart';
import 'package:harpy/components/components.dart';

/// Prevents the start of a scroll motion by increasing the
/// [dragStartDistanceMotionThreshold] based on the [viewportWidth].
///
/// This is used as the scroll physics for the horizontally scrolled
/// [HomeTabView] to make vertical scrolling easier in the nested scrollables
/// of the tab view.
class HomeTabViewScrollPhysics extends ScrollPhysics {
  const HomeTabViewScrollPhysics({
    required this.viewportWidth,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  final double viewportWidth;

  @override
  HomeTabViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HomeTabViewScrollPhysics(
      viewportWidth: viewportWidth,
      parent: buildParent(ancestor),
    );
  }

  @override
  double? get dragStartDistanceMotionThreshold => viewportWidth * .1;
}
