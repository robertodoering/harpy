import 'package:flutter/material.dart';

/// A tappable button that can be [active] and draw a different icon with a
/// different [VoidCallback].
class TwitterButton extends StatefulWidget {
  /// Whether or not the [TwitterButton] is [active].
  final bool active;

  /// The [IconData] to draw when the [TwitterButton] is not [active].
  final IconData inactiveIconData;

  /// The [IconData] to draw when the [TwitterButton] is [active].
  final IconData activeIconData;

  /// The number next to the action.
  final int value;

  /// The color of the action.
  ///
  /// If [active] is `true` the icon and value will be colored.
  /// Otherwise only when tapping the [TwitterButton] the icon, value and splash
  /// will use this [color].
  final Color color;

  /// The callback when the action has been tapped if it is not [active].
  final VoidCallback activate;

  /// The callback when the action has been tapped if it is [active].
  final VoidCallback deactivate;

  TwitterButton({
    @required this.active,
    @required this.inactiveIconData,
    @required this.activeIconData,
    @required this.value,
    @required this.color,
    @required this.activate,
    @required this.deactivate,
  });

  @override
  _TwitterButtonState createState() => _TwitterButtonState();
}

class _TwitterButtonState extends State<TwitterButton> {
  bool drawColored = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.active ? widget.deactivate : widget.activate,
      highlightColor: Colors.transparent,
      splashColor: widget.color.withOpacity(0.1),
      onHighlightChanged: updateDrawColored,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Icon(
              widget.active ? widget.activeIconData : widget.inactiveIconData,
              size: 18.0,
              color: drawColored || widget.active
                  ? widget.color
                  : Theme.of(context).iconTheme.color,
            ),
            SizedBox(width: 8.0),
            Text(
              "${widget.value}",
              style: createTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle createTextStyle() {
    TextStyle base = Theme.of(context).textTheme.body1;

    if (widget.active || drawColored) {
      return base.copyWith(color: widget.color);
    } else {
      return base;
    }
  }

  void updateDrawColored(bool drawColored) {
    setState(() {
      this.drawColored = drawColored;
    });
  }
}

class CircleButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color highlightColor;
  final Color splashColor;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  const CircleButton({
    @required this.child,
    this.backgroundColor = Colors.black26,
    this.highlightColor = Colors.white10,
    this.splashColor = Colors.white24,
    this.padding = const EdgeInsets.all(8.0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          child: Padding(
            padding: padding,
            child: child,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
