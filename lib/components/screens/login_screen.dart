import 'package:flutter/material.dart';
import 'package:harpy/stores/login_store.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: _LoginTitle(),
          ),
          Expanded(
            child: _LoginButton(),
          )
        ],
      ),
    );
  }
}

/// A title that slides into position upon creation.
class _LoginTitle extends StatefulWidget {
  @override
  _LoginTitleState createState() => _LoginTitleState();
}

class _LoginTitleState extends State<_LoginTitle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller)
      ..addListener(() => setState(() {}));

    _controller.forward();

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
          offset: Offset(0.0, (1 - _animation.value) * 100),
          child: Text(
            "Harpy",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }
}

/// A login button that slides into position with a delay upon creation.
class _LoginButton extends StatefulWidget {
  @override
  __LoginButtonState createState() => __LoginButtonState();
}

class __LoginButtonState extends State<_LoginButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1, milliseconds: 250),
    );

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller)
      ..addListener(() => setState(() {}));

    Future.delayed(Duration(milliseconds: 750))
        .then((_) => _controller.forward());

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
          offset: Offset(0.0, (1 - _animation.value) * 100),
          child: RaisedButton(
            child: Text(
              "Login with Twitter",
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: LoginStore.twitterLogin,
          ),
        ),
      ),
    );
  }
}
