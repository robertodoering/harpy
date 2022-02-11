import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/rby/rby.dart';

class FlareAnimation extends StatelessWidget {
  const FlareAnimation({
    required this.name,
    this.alignment = Alignment.center,
    this.animation,
    this.color,
  });

  final String name;
  final Alignment alignment;
  final String? animation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return isTest
        // prevent building a flare actor in tests otherwise timer will be
        // pending after the widget tree gets disposed in tests which cause the
        // test to throw an exception
        ? _TestPlaceholder(name: name)
        : FlareActor(
            'assets/flare/$name.flr',
            animation: animation,
            alignment: alignment,
            color: color,
          );
  }
}

class _TestPlaceholder extends StatelessWidget {
  const _TestPlaceholder({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all()),
        child: UnconstrainedBox(
          child: Center(
            child: Text(
              name,
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
          ),
        ),
      ),
    );
  }
}
