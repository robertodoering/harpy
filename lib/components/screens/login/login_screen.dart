import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_button.dart';
import 'package:harpy/components/screens/login/login_title.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
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

    store = listenToStore(Tokens.login);
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
            Expanded(flex: 2, child: LoginTitle()),
            Expanded(child: LoginButton(_onLoginAttempt)),
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

      // init tweets before navigating
      await HomeStore.initTweets();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}
