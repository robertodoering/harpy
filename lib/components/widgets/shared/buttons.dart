import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';

/// Used by [FlatHarpyButton] to build a different icon when the button is
/// highlighted.
///
/// Implemented in [FavoriteButton] to build a [FlareActor] icon with an
/// animation.
typedef Widget IconBuilder(BuildContext context, bool highlighted);

/// A flat button with a transparent background that can consist of either an
/// [icon], a [text] or both.
///
/// The [text] uses the body1 style of the [Theme].
class FlatHarpyButton extends StatefulWidget {
  const FlatHarpyButton({
    this.icon,
    this.iconSize = 18,
    this.iconBuilder,
    this.text,
    this.color,
    this.alwaysColored = true,
    this.onTap,
  }) : assert((icon != null || iconBuilder != null) || text != null);

  /// The [IconData] used in an [Icon] widget.
  final IconData icon;

  /// The size for the [Icon] that is build with the [icon].
  final double iconSize;

  /// The [IconBuilder] can be used to build a different icon when the button
  /// is highlighted.
  ///
  /// Not used if [icon] is not `null`.
  final IconBuilder iconBuilder;

  /// The [text] used in a [Text] widget with the body1 style of the [Theme].
  final String text;

  /// The [Color] of the text and icon.
  ///
  /// Depending on [alwaysColored] the text and icon might only be colored
  /// while the button is highlighted (pressed down).
  ///
  /// Also used with a low opacity for the splashColor of the underlying
  /// [InkWell].
  final Color color;

  /// Determines if the text and icon should always appear in the [color] or
  /// only while the button is highlighted (pressed down).
  final bool alwaysColored;

  /// Called when the button is tapped.
  final GestureTapCallback onTap;

  @override
  FlatHarpyButtonState createState() => FlatHarpyButtonState();
}

class FlatHarpyButtonState extends State<FlatHarpyButton> {
  bool _highlighted = false;

  void _onHighlightChanged(bool highlighted) {
    setState(() {
      _highlighted = highlighted;
    });
  }

  bool get _hasIcon => widget.icon != null || widget.iconBuilder != null;

  /// Gets the color for the icon and text.
  Color get _color =>
      _highlighted || widget.alwaysColored ? widget.color : null;

  /// Builds the icon from the [widget.icon] or [widget.iconBuilder].
  Widget _buildIcon(BuildContext context) {
    if (widget.icon != null) {
      return Icon(widget.icon, size: widget.iconSize, color: _color);
    }

    if (widget.iconBuilder != null) {
      return widget.iconBuilder(context, _highlighted);
    }

    return Container();
  }

  /// Builds the space between the icon and text if both are not `null`.
  Widget _buildSeparator() {
    return _hasIcon && widget.text != null ? SizedBox(width: 8.0) : Container();
  }

  /// Builds the text from the [widget.text].
  Widget _buildText(BuildContext context) {
    if (widget.text == null) {
      return Container();
    }

    return Text(
      widget.text,
      style: Theme.of(context).textTheme.body1.copyWith(color: _color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      highlightColor: Colors.transparent,
      splashColor: widget.color?.withOpacity(0.3),
      onHighlightChanged: _onHighlightChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            _buildIcon(context),
            _buildSeparator(),
            _buildText(context),
          ],
        ),
      ),
    );
  }
}

/// Builds on the [FlatHarpyButton] and has a different behavior if the button
/// is [active] or not.
class FlatHarpyActionButton extends StatelessWidget {
  const FlatHarpyActionButton({
    @required this.active,
    this.activeIcon,
    this.inactiveIcon,
    this.iconSize = 18,
    this.text,
    this.color,
    this.activate,
    this.deactivate,
  });

  final bool active;

  /// The icon that is built when [active] is `true`.
  final IconData activeIcon;

  /// The icon that is built when [active] is `false`.
  final IconData inactiveIcon;

  /// See [FlatHarpyButton].
  final double iconSize;

  /// See [FlatHarpyButton].
  final String text;

  /// See [FlatHarpyButton].
  final Color color;

  /// The callback when the button is pressed and [active] is `false`.
  final VoidCallback activate;

  /// The callback when the button is pressed and [active] is `true`.
  final VoidCallback deactivate;

  @override
  Widget build(BuildContext context) {
    return FlatHarpyButton(
      icon: active ? activeIcon : inactiveIcon,
      iconSize: iconSize,
      text: text,
      color: color,
      alwaysColored: active,
      onTap: active ? deactivate : activate,
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
