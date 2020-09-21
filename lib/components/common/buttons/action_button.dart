import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/bubble_animation.dart';
import 'package:harpy/components/common/animations/implicit/animated_number.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

/// Builds the icon for an [ActionButton].
typedef IconBuilder = Widget Function(
  BuildContext context,
  bool active,
  double size,
);

/// Builds the icon animation for an [ActionButton].
typedef IconAnimationBuilder = Widget Function(
  Animation<double> animation,
  Widget child,
);

/// Builds a [HarpyButton] for an action that has an [active] state.
///
/// A change of [active] to `true` is animated using a [BubbleAnimation] and a
/// custom [iconAnimationBuilder].
///
/// An optional numeric [value] is built as the button text with a
/// [AnimatedNumber] to implicitly animate a change of the [value].
/// The [value] is formatted using the [NumberFormat.compact].
class ActionButton extends StatefulWidget {
  const ActionButton({
    @required this.iconBuilder,
    @required this.active,
    this.iconAnimationBuilder = defaultIconAnimationBuilder,
    this.activeIconColor,
    this.value,
    this.activeTextStyle,
    this.iconSize = 20,
    this.activate,
    this.deactivate,
    this.bubblesColor = const BubblesColor(
      dotPrimaryColor: Color(0xFFFFC107),
      dotSecondaryColor: Color(0xFFFF9800),
      dotThirdColor: Color(0xFFFF5722),
      dotLastColor: Color(0xFFF44336),
    ),
    this.circleColor = const CircleColor(
      start: Color(0xFFFF5722),
      end: Color(0xFFFFC107),
    ),
  });

  /// Builds the icon for the current [active] state.
  final IconBuilder iconBuilder;

  /// Determines the animation that starts when [active] changes from `false` to
  /// `true`.
  final IconAnimationBuilder iconAnimationBuilder;

  /// The color for icon when [active] is `true`.
  final Color activeIconColor;

  /// Whether the button should appear active.
  final bool active;

  /// An optional value displayed next to the icon.
  final int value;

  /// The style for the text when [active] is `true`.
  final TextStyle activeTextStyle;

  /// The size of the icon.
  ///
  /// Also determines the sizes of the [BubbleAnimation].
  final double iconSize;

  /// The callback that is fired when the button is tapped and [active] is
  /// `false`.
  final VoidCallback activate;

  /// The callback that is fired when the button is tapped and [active] is
  /// `true`.
  final VoidCallback deactivate;

  /// The colors used by the [BubbleAnimation] that starts when [active] changes
  /// from `false` to `true`.
  final BubblesColor bubblesColor;
  final CircleColor circleColor;

  /// The default icon animation that builds the icon in a [ScaleTransition].
  static Widget defaultIconAnimationBuilder(
    Animation<double> animation,
    Widget child,
  ) {
    final Animation<double> scale = Tween<double>(begin: .2, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(.35, .7, curve: Curves.easeOutBack),
      ),
    );

    return ScaleTransition(scale: scale, child: child);
  }

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin<ActionButton> {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      value: widget.active ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(ActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.active != widget.active) {
      if (widget.active) {
        _controller.forward(from: 0);
      } else {
        // TODO: add reset animation
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget icon = AnimatedTheme(
      data: theme.copyWith(
        iconTheme: theme.iconTheme.copyWith(
          color: widget.active ? widget.activeIconColor : null,
        ),
      ),
      child: BubbleAnimation(
        controller: _controller,
        size: widget.iconSize,
        bubblesColor: widget.bubblesColor,
        circleColor: widget.circleColor,
        builder: (BuildContext context) => Container(
          width: widget.iconSize,
          height: widget.iconSize,
          alignment: Alignment.center,
          child: _controller.isAnimating || widget.active
              ? widget.iconAnimationBuilder(
                  _controller,
                  widget.iconBuilder(
                    context,
                    widget.active,
                    widget.iconSize,
                  ),
                )
              : widget.iconBuilder(
                  context,
                  widget.active,
                  widget.iconSize,
                ),
        ),
      ),
    );

    return HarpyButton.flat(
      padding: const EdgeInsets.all(8),
      onTap: widget.active ? widget.deactivate : widget.activate,
      icon: icon,
      style: widget.active ? widget.activeTextStyle : null,
      text: AnimatedNumber(
        number: widget.value,
      ),
    );
  }
}
