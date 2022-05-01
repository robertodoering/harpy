import 'package:flutter/material.dart';

/// Implements the 'unfocus on background tap' behavior for its child.
///
/// This example uses [MaterialApp.builder] to implement the 'unfocus on
/// background tap' behavior app-wide.
///
/// ```dart
/// MaterialApp(
///   home: Container(),
///   builder: (_, child) => Unfocus(child: child),
/// );
/// ```
class Unfocus extends StatelessWidget {
  const Unfocus({
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: child,
    );
  }
}
