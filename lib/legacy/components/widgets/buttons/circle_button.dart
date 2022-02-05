import 'package:flutter/material.dart';

/// Builds a simple circular button.
class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.child,
    this.onTap,
    this.color,
    this.padding = const EdgeInsets.all(8),
  });

  /// The child built inside the button.
  final Widget child;

  /// The callback when the button has been pressed.
  final VoidCallback? onTap;

  /// The background color of the button.
  ///
  /// If `null`, this button is built transparent.
  final Color? color;

  /// The padding for the [child].
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: color,
      type: color == null ? MaterialType.transparency : MaterialType.button,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
