import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_screen.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

/// The entry screen of the app.
///
/// A 'splash screen' will be drawn during initialization.
///
/// The [MainScreen] determines whether to display the [LoginScreen] or skip to
/// the [HomeScreen] if the user is already logged in.
class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with StoreWatcherMixin<MainScreen> {
  LoginStore loginStore;

  Future<void> _init() async {
    // init app config
    await AppConfiguration().init();

    // init tokens
    Tokens();

    // init tweets if already logged in before showing home screen
    if (loginStore.loggedIn) {
      await HomeStore.initTweets();
      // init user
      await UserStore.initLoggedInUser();
    }

    _checkLoggedIn();
  }

  /// Checks if the user is logged in and navigates to the [HomeScreen] or the
  /// [LoginScreen] depending on the login state.
  void _checkLoggedIn() {
    if (loginStore.loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    loginStore = listenToStore(Tokens.login);

    _init();
  }

  @override
  void dispose() {
    unlistenFromStore(loginStore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // draw splash screen
    return Material(
      color: HarpyTheme.primaryColor,
    );
  }
}
