import 'package:flutter/material.dart';

/// A login button that slides into position with a delay upon creation.
class LoginButton extends StatefulWidget {
  final VoidCallback onLoginAttempt;

  LoginButton(this.onLoginAttempt);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller)
      ..addListener(() => setState(() {}));

    Future.delayed(Duration(seconds: 1)).then((_) => _controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0.0, (1 - _animation.value) * 50),
          child: RaisedButton(
            child: Text(
              "Login with Twitter",
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: widget.onLoginAttempt,
          ),
        ),
      ),
    );
  }
}
