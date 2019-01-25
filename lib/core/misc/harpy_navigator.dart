import 'package:flutter/material.dart';

class HarpyNavigator {
  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  static void push(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  /// A convenience method to push a new replacement [MaterialPageRoute] to the
  /// [Navigator].
  static void pushReplacement(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
