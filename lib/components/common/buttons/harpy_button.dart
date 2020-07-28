import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_scale.dart';

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
      curve: Curves.easeOutCirc,
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

/// A custom button that uses an [AnimatedScale] to appear pressed down on tap.
///
/// The [HarpyButton.raised] builds a button with elevation and a
/// [backgroundColor].
///
/// The [HarpyButton.flat] builds a flat button with a transparent background.
///
/// The button can have an [icon] and [text]. When both are not `null`, the
/// icon is built to the left of the text with a padding in between that is
/// half of its vertical padding.
///
/// Alternatively to [icon], an [iconBuilder] can be used to build the icon
/// widget with more control.
///
/// When [onTap] is `null`, the button will appear disabled by reducing the
/// foreground and background opacity.
///
/// Either [icon], [iconBuilder] or [text] must not be `null`.
class HarpyButton extends StatelessWidget {
  /// A button that appears raised with a shadow.
  ///
  /// Uses the [ThemeData.buttonColor] as the [backgroundColor] by default.
  const HarpyButton.raised({
    @required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.iconBuilder,
    this.backgroundColor,
    this.dense = false,
    this.padding,
    this.foregroundColor,
  })  : materialType = MaterialType.canvas,
        elevation = 8,
        assert(text != null || icon != null || iconBuilder != null);

  /// A flat button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const HarpyButton.flat({
    @required this.onTap,
    this.text,
    this.icon,
    this.iconSize,
    this.iconBuilder,
    this.dense = false,
    this.padding,
    this.foregroundColor,
  })  : backgroundColor = null,
        materialType = MaterialType.transparency,
        elevation = 0,
        assert(text != null || icon != null || iconBuilder != null);

  /// The [text] of the button.
  ///
  /// Can be `null` if the button has no text.
  final String text;

  /// The [icon] of the button.
  ///
  /// Can be `null` if the button has no icon.
  final IconData icon;

  /// The size of the [icon];
  final double iconSize;

  /// Can be used in place of [icon] to build the icon widget.
  final WidgetBuilder iconBuilder;

  /// The callback when the button is tapped.
  ///
  /// If `null`, the button is slightly transparent to appear disabled.
  final VoidCallback onTap;

  /// The color of the button.
  ///
  /// Uses the [ThemeData.buttonColor] if `null`.
  final Color backgroundColor;

  /// The color of the [icon] and [text] of the button.
  ///
  /// Defaults to [TextTheme.button] if the [backgroundColor] is `null`,
  /// to the [TextTheme.bodyText2] color if the [backgroundColor] is transparent
  /// or to a complimentary color when [backgroundColor] is set.
  final Color foregroundColor;

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

  /// Determines the material type that the button uses as its background.
  ///
  /// Set to [MaterialType.transparency] for [HarpyButton.flat] and
  /// [MaterialType.canvas] for [HarpyButton.raised].
  final MaterialType materialType;

  EdgeInsets get _padding =>
      padding ??
      EdgeInsets.symmetric(
        vertical: dense ? 8 : 12,
        horizontal: dense ? 16 : 32,
      );

  /// Returns the color for the [icon] and [text].
  Color _getForegroundColor(ThemeData theme) {
    if (foregroundColor != null) {
      return foregroundColor;
    } else if (materialType == MaterialType.transparency) {
      // the text color since the button is transparent, therefore directly
      // on the background

      return theme.textTheme.bodyText2.color;
    } else if (backgroundColor == null) {
      // dont override the button color

      return theme.textTheme.button.color;
    } else {
      // black or white depending on the background color

      return ThemeData.estimateBrightnessForColor(backgroundColor) ==
              Brightness.light
          ? Colors.black
          : Colors.white;
    }
  }

  /// Builds the row with the [Icon] and [Text] widget.
  Widget _buildContent(BuildContext context) {
    Widget iconWidget;
    Widget textWidget;

    if (text != null) {
      // need to make sure the text overflow is handled when the button size is
      // constrained, for example during an AnimatedCrossFade transition
      textWidget = Text(
        text,
        style: Theme.of(context).textTheme.button,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    }

    if (icon != null) {
      iconWidget = Icon(icon);
    } else if (iconBuilder != null) {
      iconWidget = iconBuilder(context);
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
    final ThemeData theme = Theme.of(context);

    Color bgColor = backgroundColor ?? theme.buttonColor;
    Color fgColor = _getForegroundColor(theme);

    if (onTap == null) {
      // reduce the opacity by 50% when disabled
      bgColor = bgColor.withOpacity(max(0, bgColor.opacity - 0.5));
      fgColor = fgColor.withOpacity(max(0, fgColor.opacity - 0.5));
    }

    return _HarpyButtonBase(
      onTap: onTap,
      child: AnimatedTheme(
        data: ThemeData(
          // material background color
          canvasColor: bgColor,

          // text color
          textTheme: TextTheme(
            button: theme.textTheme.button.copyWith(color: fgColor),
          ),

          // icon color
          iconTheme: IconThemeData(color: fgColor, size: iconSize),
        ),
        child: Material(
          elevation: elevation,
          type: materialType,
          borderRadius: BorderRadius.circular(64),
          child: Padding(
            padding: _padding,
            // use a builder so the context can reference the animated theme
            child: Builder(builder: _buildContent),
          ),
        ),
      ),
    );
  }
}
