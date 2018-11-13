import 'package:flutter/material.dart';
import 'package:harpy/components/shared/animations.dart';

/// A title that slides into position upon creation.
class LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: Duration(seconds: 2),
      delay: Duration(seconds: 0),
      offset: Offset(0.0, 100.0),
      child: Text(
        "Harpy",
        style: Theme.of(context).textTheme.title.copyWith(),
      ),
    );
  }
}
