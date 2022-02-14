import 'package:flutter/widgets.dart';

class HomeTabViewScrollPhysics extends ScrollPhysics {
  const HomeTabViewScrollPhysics({
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  HomeTabViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HomeTabViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double? get dragStartDistanceMotionThreshold => 25;
}
