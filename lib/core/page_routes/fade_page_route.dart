import 'package:flutter/material.dart';

/// A [PageRoute] that fades into the new widget.
class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
    this.duration = const Duration(milliseconds: 300),
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  final Duration duration;

  @override
  final bool maintainState;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }
}
