import 'package:flutter/material.dart';

/// A [PageRoute] with a semi transparent background.
///
/// Similar to calling [showDialog] except it can be used with a [Navigator] to
/// show a [Hero] animation.
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.builder,
    this.onBackgroundTap,
  }) : super();

  final WidgetBuilder builder;

  final VoidCallback? onBackgroundTap;

  /// The color tween used in the transition to animate the background color.
  final ColorTween _colorTween = ColorTween(
    begin: Colors.black.withOpacity(0),
    end: Colors.black.withOpacity(.66),
  );

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onBackgroundTap,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: _colorTween.evaluate(animation),
          ),
        ),
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}
