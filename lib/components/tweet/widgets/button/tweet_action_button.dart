import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Builds the icon for an [TweetActionButton].
typedef IconBuilder = Widget Function(bool active);

/// Builds the icon animation for an [TweetActionButton].
typedef IconAnimationBuilder = Widget Function(
  Animation<double> animation,
  Widget icon,
);

class TweetActionButton extends ConsumerStatefulWidget {
  const TweetActionButton({
    required this.iconBuilder,
    required this.active,
    required this.activate,
    required this.deactivate,
    required this.iconSize,
    this.sizeDelta = 0,
    this.foregroundColor,
    this.iconAnimationBuilder = defaultIconAnimationBuilder,
    this.onLongPress,
    this.activeColor,
    this.inactiveColor,
    this.bubblesColor = BubbleAnimation.defaultBubblesColor,
    this.circleColor = BubbleAnimation.defaultCircleColor,
    this.value,
  });

  final WidgetBuilder iconBuilder;
  final IconAnimationBuilder iconAnimationBuilder;
  final bool active;
  final double iconSize;
  final double sizeDelta;
  final Color? foregroundColor;
  final VoidCallback activate;
  final VoidCallback? deactivate;
  final VoidCallback? onLongPress;

  final Color? activeColor;
  final Color? inactiveColor;
  final BubblesColor bubblesColor;
  final CircleColor circleColor;

  final int? value;

  static Widget defaultIconAnimationBuilder(
    Animation<double> animation,
    Widget child,
  ) {
    final scale = Tween<double>(begin: .2, end: 1)
        .chain(
          CurveTween(curve: const Interval(.35, .7, curve: Curves.easeOutBack)),
        )
        .animate(animation);

    return ScaleTransition(scale: scale, child: child);
  }

  @override
  _TweetActionButtonState createState() => _TweetActionButtonState();
}

class _TweetActionButtonState extends ConsumerState<TweetActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      value: widget.active ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant TweetActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.active != widget.active) {
      widget.active ? _controller.forward(from: 0) : _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final textStyle = theme.textTheme.button!.copyWith(
      fontSize: widget.iconSize - 4,
      height: 1,
      color: widget.active ? widget.activeColor : widget.foregroundColor,
      fontWeight: widget.active ? FontWeight.bold : null,
    );

    final icon = AnimatedTheme(
      duration: kShortAnimationDuration,
      data: theme.copyWith(
        iconTheme: theme.iconTheme.copyWith(
          color: widget.active ? widget.activeColor : widget.foregroundColor,
        ),
      ),
      child: BubbleAnimation(
        controller: _controller,
        size: widget.iconSize,
        bubblesColor: widget.bubblesColor,
        circleColor: widget.circleColor,
        builder: (_) => _controller.isAnimating
            ? widget.iconAnimationBuilder(
                _controller,
                widget.iconBuilder(context),
              )
            : widget.iconBuilder(context),
      ),
    );

    final label = widget.value != null
        ? AnimatedDefaultTextStyle(
            duration: kShortAnimationDuration,
            style: textStyle,
            maxLines: 1,
            child: AnimatedNumber(
              duration: kShortAnimationDuration,
              number: widget.value!,
            ),
          )
        : null;

    final style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? (widget.foregroundColor ?? theme.colorScheme.onBackground)
                .withOpacity(.5)
            : widget.foregroundColor ?? theme.colorScheme.onBackground,
      ),
      overlayColor: MaterialStateProperty.all(theme.highlightColor),
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(
        display.edgeInsets + EdgeInsets.all(widget.sizeDelta),
      ),
    );

    return TextButton(
      onPressed: widget.active ? widget.deactivate : widget.activate,
      onLongPress: widget.onLongPress,
      style: style,
      child: AnimatedSize(
        duration: kShortAnimationDuration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            icon,
            if (label != null) ...[
              smallHorizontalSpacer,
              label,
            ],
          ],
        ),
      ),
    );
  }
}
