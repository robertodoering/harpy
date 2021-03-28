import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds the [bubble] widget above the [child] in the top right.
///
/// The [bubble] widget is typically a [Bubble].
class Bubbled extends StatelessWidget {
  const Bubbled({
    @required this.child,
    this.bubble,
    this.bubbleOffset,
  });

  final Widget child;
  final Widget bubble;
  final Offset bubbleOffset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        child,
        if (bubble != null && bubbleOffset != null)
          Transform.translate(
            offset: bubbleOffset,
            child: IgnorePointer(child: bubble),
          )
        else if (bubble != null)
          IgnorePointer(child: bubble),
      ],
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: theme.accentColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
