import 'package:flutter/material.dart';

class HarpyNavigator {
  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  static void push(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }
}
