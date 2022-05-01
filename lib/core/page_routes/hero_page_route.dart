import 'package:flutter/material.dart';

/// A simple [PageRoute] with a semi transparent background.
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.builder,
  }) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Center(
      child: FadeTransition(
        opacity: CurvedAnimation(curve: Curves.easeInOut, parent: animation),
        child: child,
      ),
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
