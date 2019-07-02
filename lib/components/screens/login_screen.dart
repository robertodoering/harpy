import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:provider/provider.dart';

/// Shows a [HarpyTitle] and a [LoginButton] to allow a user to login.
class LoginScreen extends StatelessWidget {
  final GlobalKey<SlideAnimationState> _slideLoginKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildLoginScreen(BuildContext context, LoginModel model) {
    return SlideAnimation(
      key: _slideLoginKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -MediaQuery.of(context).size.height),
      child: Column(
        children: <Widget>[
          _buildText(),
          _buildButtons(model),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SecondaryDisplayText("welcome to"),
          const SizedBox(height: 16),
          const PrimaryDisplayText(
            "Harpy",
            delay: Duration(milliseconds: 800),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(LoginModel model) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          LoginButton(onTap: () => _startLogin(model)),
          const SizedBox(height: 8),
          CreateAccountButton(),
        ],
      ),
    );
  }

  Future<void> _startLogin(LoginModel model) async {
    await _slideLoginKey.currentState.forward();
    model.login();
  }

  @override
  Widget build(BuildContext context) {
    final applicationModel = ApplicationModel.of(context);

    return Material(
      color: Colors.transparent,
      child: HarpyBackground(
        child: Consumer<LoginModel>(
          builder: (context, model, _) {
            if (!applicationModel.loggedIn) {
              return _buildLoginScreen(context, model);
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 2800),
      child: RaisedHarpyButton(
        text: "Login with Twitter",
        onTap: onTap,
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 3000),
      child: NewFlatHarpyButton(
        text: "Create an account",
        onTap: () => launchUrl("https://twitter.com/signup"),
      ),
    );
  }
}
