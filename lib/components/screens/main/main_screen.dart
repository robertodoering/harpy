import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/components/screens/home/home_screen.dart';
import 'package:harpy/components/screens/login/login_screen.dart';
import 'package:harpy/components/shared/harpy_title.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

/// The entry screen of the app.
///
/// A 'splash screen' with the title will be drawn during initialization.
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

  /// Flags to make sure the initialization and the title animation has
  /// completed before navigating to the next screen.
  bool initialized = false;
  bool animationFinished = false;

  HarpyTitle harpyTitle;

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
      if (loginStore.loggedIn) {
        await harpyTitle.fadeOut();

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
  void initState() {
    super.initState();

    loginStore = listenToStore(Tokens.login);

    harpyTitle = HarpyTitle(
      key: harpyTitleKey,
      finishCallback: () => _checkLoggedIn(animationFinished: true),
    );

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
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: harpyTitle,
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
