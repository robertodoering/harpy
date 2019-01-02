import 'package:flutter/material.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_screen.dart';
import 'package:harpy/components/shared/harpy_title.dart';
import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

/// The entry screen of the app.
///
/// A 'splash screen' with the title will be drawn during initialization.
///
/// The [MainScreen] initializes the app and determines whether to display the
/// [LoginScreen] or skip to the [HomeScreen] if the user is already logged in.
class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  /// Flags to make sure the initialization and the title animation has
  /// completed before navigating to the next screen.
  bool initialized = false;
  bool animationFinished = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    // init app config
    await AppConfiguration().init();

    // init tokens
    Tokens();

    // init tweets if already logged in before showing home screen
    if (AppConfiguration().twitterSession != null) {
      await HomeStore.initTweets();
      // init user
      await UserStore.initLoggedInUser();
    }

    _checkLoggedIn(initialized: true);
  }

  /// Checks if the user is logged in and navigates to the [HomeScreen] or the
  /// [LoginScreen] depending on the login state.
  void _checkLoggedIn({
    bool initialized,
    bool animationFinished,
  }) async {
    if (initialized != null) this.initialized = initialized;
    if (animationFinished != null) this.animationFinished = animationFinished;

    // only navigate when ready
    if (this.initialized && this.animationFinished) {
      if (LoginStore.loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          // route without a transition animation
          PageRouteBuilder(
            pageBuilder: (context, _a, _b) => LoginScreen(),
            transitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // draw splash screen
    return Theme(
      data: HarpyTheme.light().theme,
      child: Material(
        color: HarpyTheme.harpyColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: HarpyTitle(
                  finishCallback: () => _checkLoggedIn(animationFinished: true),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
