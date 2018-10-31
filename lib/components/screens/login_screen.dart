import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/stores/login_store.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with StoreWatcherMixin {
  LoginStore store;

  bool loggedIn = false;

  _LoginScreenState() {
    store = listenToStore(loginStoreToken);
  }

  @override
  void dispose() {
    super.dispose();
    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(flex: 2, child: _LoginTitle()),
          Expanded(child: _buildLoginButton()),
        ],
      ),
    );
  }

  /// Checks if a session exists and we are logged in.
  ///
  /// Builds the [_LoginButton] if we are not logged in.
  /// Routes to the [HomeScreen] if we are logged in.
  /// Shows a [CircularProgressIndicator] while obtaining the login information.
  Widget _buildLoginButton() {
    return FutureBuilder(
      future: store.loggedIn,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data as bool) {
            // logged in, go to home screen
            if (loggedIn) _navigateToHomeScreen();

            return Container();
          } else {
            // not logged in, show login button
            return _LoginButton();
          }
        } else {
          // loading last session
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _navigateToHomeScreen() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Container()),
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
            onPressed: LoginStore.twitterLogin,
          ),
        ),
      ),
    );
  }
}
