import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with StoreWatcherMixin<LoginScreen> {
  LoginStore store;

  @override
  void initState() {
    super.initState();

    store = listenToStore(loginStoreToken);
  }

  @override
  void dispose() {
    super.dispose();

    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: Material(
        color: HarpyTheme.primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(flex: 2, child: _LoginTitle()),
            Expanded(child: _LoginButton(_onLoginAttempt)),
          ],
        ),
      ),
    );
  }

  Future<void> _onLoginAttempt() async {
    TwitterLoginResult result = await store.login;

    if (result.status == TwitterLoginStatus.loggedIn) {
      // successfully logged in; save session and navigate to home screen
      LoginStore.setSession(result.session);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
  final VoidCallback onLoginAttempt;

  _LoginButton(this.onLoginAttempt);

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
