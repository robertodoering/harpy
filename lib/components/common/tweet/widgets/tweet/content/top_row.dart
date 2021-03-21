import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TweetTopRow extends StatelessWidget {
  const TweetTopRow({
    @required this.begin,
    @required this.beginPadding,
    @required this.end,
  });

  final List<Widget> begin;
  final EdgeInsets beginPadding;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: AnimatedPadding(
            duration: kShortAnimationDuration,
            padding: beginPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: begin,
            ),
          ),
        ),
        end,
      ],
    );
  }
}
