import 'package:flutter/material.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({
    @required this.child,
    this.margin = const EdgeInsets.all(4),
  });

  final Widget child;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: kDefaultBorderRadius,
              // shape: BoxShape.circle,
              color: theme.canvasColor.withOpacity(.4),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
