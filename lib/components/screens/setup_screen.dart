import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/components/widgets/theme/theme_selection.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/login_model.dart';

/// The [SetupScreen] is shown when a user logged into the app for the first
/// time.
class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final GlobalKey<SlideAnimationState> _slideInitializationKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildInitializationScreen(BuildContext context) {
    return SlideAnimation(
      key: _slideInitializationKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -MediaQuery.of(context).size.height),
      child: Column(
        children: <Widget>[
          _buildTop(context),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SecondaryDisplayText("welcome"),
          const SizedBox(height: 16),
          PrimaryDisplayText(
            loginModel.loggedInUser.name,
            style: Theme.of(context).textTheme.display3,
            overflow: TextOverflow.ellipsis,
            delay: const Duration(milliseconds: 800),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          const SecondaryDisplayText(
            "select your theme",
            textAlign: TextAlign.center,
            delay: Duration(milliseconds: 3000),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: SlideFadeInAnimation(
              delay: Duration(milliseconds: 3000),
              duration: Duration(seconds: 1),
              offset: Offset(0, 50),
              curve: Curves.easeInOut,
              child: ThemeSelection(
                delay: Duration(milliseconds: 3000),
              ),
            ),
          ),
          Spacer(),
          BounceInAnimation(
            delay: const Duration(milliseconds: 4000),
            child: NewFlatHarpyButton(
              text: "continue",
              onTap: _navigateToHome,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToHome() async {
    await _slideInitializationKey.currentState.forward();
    HarpyNavigator.pushReplacement(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: HarpyBackground(
        child: _buildInitializationScreen(context),
      ),
    );
  }
}
