import 'package:flutter/material.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:logging/logging.dart';

/// The screen shown during the start of the app.
///
/// A 'splash screen' with the title will be drawn during initialization.
///
/// After initialization the [EntryScreen] will navigate to the [LoginScreen] or
/// skip to the [HomeScreen] if the user is already logged in
class EntryScreen extends StatelessWidget {
  static final Logger _log = Logger("EntryScreen");

  @override
  Widget build(BuildContext context) {
    final applicationModel = ApplicationModel.of(context);

    applicationModel.onInitialized = () {
      _onInitialized(context, applicationModel);
    };

    return Material(
      color: HarpyTheme.harpyColor,
    );
  }

  Future<void> _onInitialized(
    BuildContext context,
    ApplicationModel model,
  ) async {
    _log.fine("on initialized");

    if (model.loggedIn) {
      final loginModel = LoginModel.of(context);
      await loginModel.initBeforeHome();

      _log.fine("navigating to home screen");
      HarpyNavigator.pushReplacementRoute(FadeRoute(
        builder: (context) => HomeScreen(),
      ));
    } else {
      _log.fine("navigating to login screen");
      // route without a transition
      HarpyNavigator.pushReplacementRoute(PageRouteBuilder(
        pageBuilder: (context, _a, _b) => LoginScreen(),
        transitionDuration: Duration.zero,
      ));
    }
  }
}
