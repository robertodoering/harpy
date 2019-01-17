import 'package:flutter/material.dart';
import 'package:harpy/widgets/shared/animations.dart';

/// A login button that slides into position with a delay upon creation.
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideFadeInAnimation(
        duration: Duration(seconds: 1),
        offset: Offset(0.0, 50.0),
        child: RaisedButton(
          child: Text(
            "Login with Twitter",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
