import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_button.dart';
import 'package:harpy/components/screens/login/login_title.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with StoreWatcherMixin<LoginScreen>, TickerProviderStateMixin {
  LoginStore store;

  bool loggingIn = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    store = listenToStore(Tokens.login);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 400,
      ),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();

    unlistenFromStore(store);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double titlePosition = MediaQuery.of(context).size.height / 3;

    // todo:
    // draw title separately from login screen
    // only draw login button in login screen below the title
    // when already logged in fade title to top and navigate to home screen

    return Theme(
      data: HarpyTheme.theme,
      child: Material(
        color: HarpyTheme.primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: lerpDouble(1.0, 0.0, _controller.value),
                child: Transform.translate(
                  offset: Offset(
                    0.0,
                    lerpDouble(
                        titlePosition, titlePosition / 2.5, _controller.value),
                  ),
                  child: Transform.scale(
                    alignment: Alignment.topCenter,
                    scale: lerpDouble(1.0, 0.8, _controller.value),
                    child: LoginTitle(),
                  ),
                ),
              ),
            ),
            Expanded(
                child: loggingIn ? Container() : LoginButton(_onLoginAttempt)),
          ],
        ),
      ),
    );
  }

  Future<void> _onLoginAttempt() async {
    TwitterLoginResult result = await store.login;

    if (result.status == TwitterLoginStatus.loggedIn) {
      setState(() {
        loggingIn = true;
      });

      // successfully logged in; save session and navigate to home screen
      LoginStore.setSession(result.session);

      // init tweets before navigating
      await HomeStore.initTweets();

      // init logged in user
      await UserStore.initLoggedInUser();

      // todo: show hero animation
      await _controller.forward();
//      await Future.delayed(Duration(milliseconds: 600));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // todo: maybe show error
      setState(() {
        loggingIn = false;
      });
    }
  }
}
