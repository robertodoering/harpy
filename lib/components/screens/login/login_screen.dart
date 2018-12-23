import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_button.dart';
import 'package:harpy/components/shared/harpy_title.dart';
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
  HarpyTitle loginTitle;

  @override
  void initState() {
    super.initState();

    store = listenToStore(Tokens.login);

    loginTitle = HarpyTitle(
      key: harpyTitleKey,
      skipIntroAnimation: true,
    );
  }

  @override
  void dispose() {
    super.dispose();

    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme().theme,
      child: Material(
        color: HarpyTheme.harpyColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: loginTitle,
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

//      await loginTitle.fadeOut();

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
