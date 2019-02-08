import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';

/// A rectangular button that can have an an [icon], [text] or both.
class HarpyButton extends StatefulWidget {
  const HarpyButton({
    this.icon,
    this.text,
    this.onPressed,
    this.iconColor,
    this.textColor,
    this.splashColor,
    this.borderColor,
    this.backgroundColor,
    this.drawColorOnHighlight = false,
    this.borderRadius,
  }) : assert(icon != null || text != null);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  final Color iconColor;
  final Color textColor;
  final Color splashColor;
  final Color borderColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  /// When `true`, the text and icon will only be drawn colored when the button
  /// is hovered (pressing but not letting go).
  final bool drawColorOnHighlight;

  @override
  HarpyButtonState createState() => HarpyButtonState();
}

class HarpyButtonState extends State<HarpyButton> {
  bool _highlighted = false;

  Widget _buildIcon() {
    Color iconColor;

    if (widget.iconColor != null && !widget.drawColorOnHighlight) {
      // always draw colored
      iconColor = widget.iconColor;
    } else if (widget.iconColor != null) {
      // only draw colored when highlighting
      iconColor =
          _highlighted ? widget.iconColor : Theme.of(context).iconTheme.color;
    } else {
      // use default color
      iconColor = Theme.of(context).iconTheme.color;
    }

    return widget.icon != null
        ? Icon(
            widget.icon,
            size: 18,
            color: iconColor,
          )
        : Container();
  }

  Widget _buildSeparator() {
    // space between icon and text
    return widget.icon != null && widget.text != null
        ? SizedBox(width: 8.0)
        : Container();
  }

  Widget _buildText() {
    if (widget.text != null) {
      TextStyle style = Theme.of(context).textTheme.body1;

      if (widget.textColor != null && !widget.drawColorOnHighlight) {
        // always draw colored
        style = style.copyWith(color: widget.textColor);
      } else if (widget.textColor != null && _highlighted) {
        // only draw colored when highlighting
        style = style.copyWith(color: widget.textColor);
      }

      return Text(widget.text, style: style);
    } else {
      return Container();
    }
  }

  void _updateHighlighted(bool highlighted) {
    setState(() {
      _highlighted = highlighted;
    });
  }

  Decoration _buildBoxDecoration() {
    if (widget.borderColor == null && widget.backgroundColor == null) {
      return null;
    }

    return BoxDecoration(
      borderRadius: widget.borderRadius,
      color: widget.backgroundColor,
      border: Border.all(color: widget.borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: widget.onPressed,
        highlightColor: Colors.transparent,
        splashColor: widget.splashColor?.withOpacity(0.1),
        onHighlightChanged: _updateHighlighted,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: <Widget>[
              _buildIcon(),
              _buildSeparator(),
              _buildText(),
            ],
          ),
        ),
      ),
    );
  }
}

/// A tappable button that can be [active] to have a different behavior and be
/// drawn colored compared to when it is inactive.
class TwitterActionButton extends StatelessWidget {
  const TwitterActionButton({
    @required this.active,
    this.inactiveIcon,
    this.activeIcon,
    this.text,
    this.color,
    this.activate,
    this.deactivate,
  });

  /// Whether or not the [TwitterActionButton] is [active].
  final bool active;

  /// The [IconData] to draw when the [TwitterActionButton] is not [active].
  final IconData inactiveIcon;

  /// The [IconData] to draw when the [TwitterActionButton] is [active].
  final IconData activeIcon;

  /// The number next to the action.
  final String text;

  /// The color of the action.
  ///
  /// If [active] is `true` the icon and value will be colored.
  /// Otherwise only when tapping the [TwitterActionButton] the icon, text and
  /// splash will use this [color].
  final Color color;

  /// The callback when the action has been tapped if it is not [active].
  final VoidCallback activate;

  /// The callback when the action has been tapped if it is [active].
  final VoidCallback deactivate;

  @override
  Widget build(BuildContext context) {
    return HarpyButton(
      icon: active ? activeIcon : inactiveIcon,
      text: text,
      onPressed: active ? deactivate : activate,
      iconColor: color,
      textColor: color,
      splashColor: color,
      drawColorOnHighlight: !active,
    );
  }
}

class CircleButton extends StatelessWidget {
  const CircleButton({
    @required this.child,
    this.backgroundColor = Colors.black26,
    this.highlightColor = Colors.white10,
    this.splashColor = Colors.white24,
    this.padding = const EdgeInsets.all(8.0),
    this.onPressed,
  });

  final Widget child;
  final Color backgroundColor;
  final Color highlightColor;
  final Color splashColor;
  final EdgeInsets padding;
  final VoidCallback onPressed;

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

/// A login button that slides into position with a delay upon creation.
class LoginButton extends StatelessWidget {
  const LoginButton({
    @required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideFadeInAnimation(
        duration: Duration(seconds: 1),
        offset: Offset(0.0, 50.0),
        child: RaisedButton(
          child: Text(
            "Login with Twitter",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
