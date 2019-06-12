import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/models/login_model.dart';

/// The [SetupScreen] is shown when a user logged into the app for the first
/// time.
class SetupScreen extends StatelessWidget {
  final GlobalKey<SlideAnimationState> _slideInitializationKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildInitializationScreen(BuildContext context) {
    return SlideAnimation(
      key: _slideInitializationKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -MediaQuery.of(context).size.height),
      child: Column(
        children: <Widget>[
          _buildText(context),
          _buildContinue(),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SubtitleText("welcome"),
          SizedBox(height: 16),
          TitleText(
            loginModel.loggedInUser.name,
            fontSize: 48,
            overflow: TextOverflow.ellipsis,
            delay: const Duration(milliseconds: 800),
          ),
          SizedBox(height: 64),
          SubtitleText(
            "please take a moment to setup your experience",
            textAlign: TextAlign.center,
            delay: const Duration(milliseconds: 3000),
          ),
        ],
      ),
    );
  }

  Widget _buildContinue() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          BounceInAnimation(
            delay: const Duration(milliseconds: 4000),
            child: HarpyButton.flat(
              text: "continue",
              textColor: Colors.white,
              // todo: go to next setup page
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[Colors.black, Color(0xff17233d)],
          ),
        ),
        child: _buildInitializationScreen(context),
      ),
    );
  }
}
