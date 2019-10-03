import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/texts.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';

/// Shows the app title and a [_LoginButton] to allow a user to login.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<SlideAnimationState> _slideLoginKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildLoginScreen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SlideAnimation(
      key: _slideLoginKey,
      duration: const Duration(milliseconds: 600),
      endPosition: Offset(0, -mediaQuery.size.height),
      child: Column(
        children: <Widget>[
          _buildText(),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                _buildTitle(context),
                _buildLogo(),
              ],
            ),
          ),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildText() {
    return const Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SecondaryDisplayText("welcome to"),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final color = Theme.of(context).textTheme.body1.color;

    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 2 / 3,
        child: SlideInAnimation(
          duration: const Duration(seconds: 3),
          offset: const Offset(0, 20),
          delay: const Duration(milliseconds: 800),
          child: FlareActor(
            "assets/flare/harpy_title.flr",
            alignment: Alignment.bottomCenter,
            animation: "show",
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Expanded(
      child: SlideInAnimation(
        duration: Duration(seconds: 3),
        offset: Offset(0, 20),
        delay: Duration(milliseconds: 800),
        child: FlareActor(
          "assets/flare/harpy_logo.flr",
          animation: "show",
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _LoginButton(onTap: () => _startLogin(loginModel)),
          const SizedBox(height: 8),
          _CreateAccountButton(),
        ],
      ),
    );
  }

  Future<void> _startLogin(LoginModel loginModel) async {
    await _slideLoginKey.currentState.forward();
    loginModel.login();
  }

  @override
  Widget build(BuildContext context) {
    final applicationModel = ApplicationModel.of(context);

    return Material(
      color: Colors.transparent,
      child: HarpyBackground(
        child: applicationModel.loggedIn
            ? const Center(child: CircularProgressIndicator())
            : _buildLoginScreen(context),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 2800),
      child: HarpyButton.raised(
        text: "Login with Twitter",
        onTap: onTap,
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 3000),
      child: HarpyButton.flat(
        text: "Create an account",
        onTap: () => launchUrl("https://twitter.com/signup"),
      ),
    );
  }
}
