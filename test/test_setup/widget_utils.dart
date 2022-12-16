import 'package:flutter/widgets.dart';

Widget buildSingleSliver(Widget sliver) {
  return CustomScrollView(slivers: [sliver]);
}
