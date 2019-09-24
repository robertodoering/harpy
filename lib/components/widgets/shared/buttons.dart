import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/implicit_animations.dart';

/// Used by [FlatHarpyButton] to build a different icon when the button is
/// highlighted.
///
/// Implemented in [FavoriteButton] to build a [FlareActor] icon with an
/// animation.
typedef IconBuilder = Widget Function(BuildContext context, bool highlighted);

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
    return _hasIcon && widget.text != null
        ? const SizedBox(width: 8)
        : Container();
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    this.padding = const EdgeInsets.all(8),
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
    return Material(
      type: MaterialType.circle,
      color: backgroundColor,
      child: InkWell(
        highlightColor: highlightColor,
        splashColor: splashColor,
        onTap: onPressed,
        customBorder: CircleBorder(),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// The base for the [HarpyButton].
///
/// Uses [AnimatedScale] to have the button appear pressed down while it is
/// tapped.
class _HarpyButtonBase extends StatefulWidget {
  const _HarpyButtonBase({
    @required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  _HarpyButtonBaseState createState() => _HarpyButtonBaseState();
}

class _HarpyButtonBaseState extends State<_HarpyButtonBase> {
  bool _tapDown = false;

  void _updateTapDown(bool value) {
    if (widget.onTap != null && _tapDown != value) {
      setState(() {
        _tapDown = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _tapDown ? .9 : 1,
      child: GestureDetector(
        onTapDown: (_) => _updateTapDown(true),
        onTapUp: (_) => _updateTapDown(false),
        onTapCancel: () => _updateTapDown(false),
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}

/// A custom button with a rounded border that uses an [AnimatedScale] to
/// appear pressed down on tap.
///
/// The [HarpyButton.raised] builds a button with elevation and a
/// [backgroundColor].
///
/// The [HarpyButton.flat] builds a flat button and a transparent
/// [backgroundColor].
///
/// The button can have an [icon] and [text]. When both are not `null`, the
/// icon is built to the left of the text with a padding in between that is
/// half of its vertical padding.
///
/// Either [icon] or [text] must not be `null`.
class HarpyButton extends StatelessWidget {
  /// A button that appears raised with a shadow.
  ///
  /// Uses the [ThemeData.buttonColor] as the [backgroundColor] by default.
  const HarpyButton.raised({
    @required this.onTap,
    this.text,
    this.icon,
    this.backgroundColor,
    this.dense = false,
    this.padding,
  })  : elevation = 8,
        assert(text != null || icon != null);

  /// A flat button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const HarpyButton.flat({
    @required this.onTap,
    this.text,
    this.icon,
    this.dense = false,
    this.padding,
  })  : backgroundColor = Colors.transparent,
        elevation = 0,
        assert(text != null || icon != null);

  /// The [text] of the button.
  ///
  /// Can be `null` if the button has no text.
  final String text;

  /// The [icon] of the button.
  ///
  /// Can be `null` if the button has no icon.
  final IconData icon;

  /// The callback when the button is tapped.
  ///
  /// If `null`, the button is slightly transparent to appear disabled.
  final VoidCallback onTap;

  /// The color of the button.
  ///
  /// Uses the [ThemeData.buttonColor] if `null`.
  final Color backgroundColor;

  /// Whether or not the button should have less padding.
  ///
  /// Has no effect if [padding] is not `null`.
  final bool dense;

  /// The padding for the button.
  ///
  /// Should usually be `null` to use the default padding that is controlled
  /// with [dense] if a smaller padding is required.
  final EdgeInsets padding;

  /// The [elevation] that changes when using a [HarpyButton.flat] or
  /// [HarpyButton.raised].
  final double elevation;

  EdgeInsets get _padding =>
      padding ??
      EdgeInsets.symmetric(
        vertical: dense ? 8 : 12,
        horizontal: dense ? 16 : 32,
      );

  /// Builds the row with the [Icon] and [Text] widget.
  Widget _buildContent(ThemeData theme) {
    Widget iconWidget;
    Widget textWidget;

    if (text != null) {
      final style = backgroundColor != null
          ? theme.textTheme.button.copyWith(color: theme.textTheme.body1.color)
          : theme.textTheme.button;

      // make sure the text overflow is handled when the button size is
      // constrained, for example during an AnimatedCrossFade transition
      textWidget = Text(
        text,
        style: style,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    }

    if (icon != null) {
      iconWidget = Icon(icon);
    }

    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (iconWidget != null) iconWidget,
          if (iconWidget != null && textWidget != null)
            SizedBox(width: _padding.vertical / 4),
          if (textWidget != null) Expanded(child: textWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(64);

    Color color = backgroundColor ?? theme.buttonColor;
    if (onTap == null) {
      color = color.withOpacity(0.7);
    }

    return _HarpyButtonBase(
      onTap: onTap,
      child: Material(
        color: color,
        elevation: elevation,
        borderRadius: borderRadius,
        child: Padding(
          padding: _padding,
          child: _buildContent(theme),
        ),
      ),
    );
  }
}
