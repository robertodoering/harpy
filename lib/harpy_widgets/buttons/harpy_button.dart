import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// The base for the [HarpyButton].
///
/// Uses an [AnimatedScale] to have the button appear pressed down while it is
/// tapped.
class _HarpyButtonBase extends StatefulWidget {
  const _HarpyButtonBase({
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

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
      scale: _tapDown ? .8 : 1,
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCirc,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _updateTapDown(true),
        onTapUp: (_) => _updateTapDown(false),
        onTapCancel: () => _updateTapDown(false),
        onLongPress: widget.onLongPress,
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
/// When [onTap] is `null`, the button will appear disabled by reducing the
/// foreground and background opacity.
///
/// Either [icon] or [text] must not be `null`.
class HarpyButton extends StatelessWidget {
  /// A button that appears raised with a shadow.
  ///
  /// Uses the [HarpyTheme.foregroundColor] as the [backgroundColor] by default.
  const HarpyButton.raised({
    required this.onTap,
    this.onLongPress,
    this.text,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.dense = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor,
    this.style,
    double? elevation,
  })  : materialType = MaterialType.canvas,
        elevation = elevation ?? 8,
        assert(text != null || icon != null);

  /// A flat button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const HarpyButton.flat({
    required this.onTap,
    this.onLongPress,
    this.text,
    this.icon,
    this.iconSize,
    this.dense = false,
    this.padding,
    this.betweenPadding,
    this.foregroundColor,
    this.style,
  })  : backgroundColor = null,
        materialType = MaterialType.transparency,
        elevation = 0,
        assert(text != null || icon != null);

  static _HarpyButtonBase custom({
    required Widget child,
    required VoidCallback? onTap,
  }) =>
      _HarpyButtonBase(
        onTap: onTap,
        child: child,
      );

  /// The text widget of the button.
  ///
  /// Can be `null` if the button has no text.
  final Widget? text;

  /// The icon widget of the button.
  ///
  /// Can be `null` if the button has no icon.
  final Widget? icon;

  /// The size of the [icon].
  ///
  /// Defaults to the current icon theme's size.
  final double? iconSize;

  /// The callback when the button is tapped.
  ///
  /// If `null`, the button has reduced transparency to appear disabled.
  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  /// The color of the button.
  ///
  /// Uses the [HarpyTheme.foregroundColor] if `null`.
  final Color? backgroundColor;

  /// The color of the [icon] and [text] of the button.
  ///
  /// Defaults to [TextTheme.button] if the [backgroundColor] is `null`,
  /// to the text foreground color if the [backgroundColor] is transparent or to
  /// white or black when [backgroundColor] is set.
  final Color? foregroundColor;

  /// Merges the [TextTheme.button] style with this [style] to use as the text
  /// style.
  final TextStyle? style;

  /// Whether the button should have less padding.
  ///
  /// Has no effect if [padding] is not `null`.
  final bool dense;

  /// The padding for the button.
  ///
  /// Should usually be `null` to use the default padding that is controlled
  /// with [dense] if a smaller padding is required.
  final EdgeInsets? padding;

  /// The padding between the [icon] and [text].
  ///
  /// Only has an affect when both [icon] and [text] is not `null`.
  ///
  /// Defaults to half of the vertical padding.
  final double? betweenPadding;

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
  Color _calculateForegroundColor(ThemeData theme) {
    if (foregroundColor != null) {
      return foregroundColor!;
    } else if (materialType == MaterialType.transparency) {
      // the text color since the button is transparent, therefore directly
      // on the background

      return theme.textTheme.bodyText2!.color!;
    } else if (backgroundColor == null) {
      // don't override the button color

      return theme.textTheme.button!.color!;
    } else {
      // black or white depending on the background color

      final colorOnBackground = Color.lerp(
        theme.backgroundColor,
        backgroundColor,
        backgroundColor!.opacity,
      )!;

      return ThemeData.estimateBrightnessForColor(colorOnBackground) ==
              Brightness.light
          ? Colors.black
          : Colors.white;
    }
  }

  /// Builds the row with the [Icon] and [Text] widget.
  Widget _buildContent() {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && text != null)
            SizedBox(width: betweenPadding ?? _padding.horizontal / 2),
          if (text != null) Expanded(child: text!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = context.watch<HarpyTheme>();

    var bgColor = backgroundColor ?? harpyTheme.foregroundColor;
    var fgColor = _calculateForegroundColor(theme);

    if (onTap == null) {
      // reduce the opacity by 50% when disabled
      bgColor = bgColor.withOpacity(max(0, bgColor.opacity - .5));
      fgColor = fgColor.withOpacity(max(0, fgColor.opacity - .5));
    }

    return _HarpyButtonBase(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedTheme(
        data: theme.copyWith(
          // material background color
          canvasColor: bgColor,

          // text color
          textTheme: TextTheme(
            button: theme.textTheme.button!.copyWith(color: fgColor),
          ),

          // icon color
          iconTheme: theme.iconTheme.copyWith(color: fgColor, size: iconSize),
        ),
        child: Material(
          elevation: elevation,
          type: materialType,
          borderRadius: kBorderRadius,
          child: Padding(
            padding: _padding,
            // use a builder so the context can reference the animated theme
            child: Builder(
              builder: (context) => DefaultTextStyle(
                style: Theme.of(context).textTheme.button!.merge(style),
                overflow: TextOverflow.fade,
                softWrap: false,
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
