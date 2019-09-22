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
  final GlobalKey<SlideAnimationState> _slideSetupKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildSetupScreen() {
    final mediaQuery = MediaQuery.of(context);

    return SlideAnimation(
      key: _slideSetupKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -mediaQuery.size.height),
      child: Column(
        children: <Widget>[
          _buildText(),
          const SizedBox(height: 16),
          _buildUserName(),
          const SizedBox(height: 16),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildText() {
    return const Expanded(
      flex: 2,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SecondaryDisplayText("welcome"),
      ),
    );
  }

  Widget _buildUserName() {
    final loginModel = LoginModel.of(context);

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FractionallySizedBox(
          widthFactor: 2 / 3,
          child: FittedBox(
            child: PrimaryDisplayText(
              loginModel.loggedInUser.name,
              style: Theme.of(context).textTheme.display3,
              delay: const Duration(milliseconds: 800),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
      flex: 4,
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
            child: HarpyButton.flat(
              text: "continue",
              onTap: _navigateToHome,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToHome() async {
    await _slideSetupKey.currentState.forward();
    HarpyNavigator.pushReplacement(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: HarpyBackground(
        child: _buildSetupScreen(),
      ),
    );
  }
}
