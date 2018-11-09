import 'package:flutter/material.dart';

/// A title that slides into position upon creation.
class LoginTitle extends StatefulWidget {
  @override
  _LoginTitleState createState() => _LoginTitleState();
}

class _LoginTitleState extends State<LoginTitle>
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
