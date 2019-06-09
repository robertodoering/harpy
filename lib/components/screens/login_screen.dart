import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:provider/provider.dart';

/// Shows a [HarpyTitle] and a [LoginButton] to allow a user to login.
class LoginScreen extends StatelessWidget {
  final GlobalKey<SlideAnimationState> _slideKey =
      GlobalKey<SlideAnimationState>();

  Widget _buildButtons(BuildContext context) {
    final applicationModel = ApplicationModel.of(context);

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WelcomeTo(),
              SizedBox(height: 16),
              HarpyTitle(),
            ],
          ),
        ),
        Expanded(
          child: Consumer<LoginModel>(
            builder: (context, model, _) {
              if (model.authorizing || applicationModel.loggedIn) {
                return Container();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    LoginButton(onTap: () => _startLogin(model)),
                    SizedBox(height: 8),
                    CreateAccountButton(),
                    SizedBox(height: 16),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _startLogin(LoginModel model) async {
    await _slideKey.currentState.forward();
    model.login();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[Colors.black, Color(0xff17233d)],
          ),
        ),
        child: SlideAnimation(
          key: _slideKey,
          duration: const Duration(milliseconds: 600),
          endPosition: Offset(0, -MediaQuery.of(context).size.height),
          child: _buildButtons(context),
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
      child: HarpyButton.raised(
        text: Text(
          "Login with Twitter",
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Color(0xff17233d), fontSize: 16),
        ),
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
      child: HarpyButton.flat(
        text: Text(
          "Create an account",
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class WelcomeTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: Duration(seconds: 1),
      offset: Offset(0.0, 50.0),
      child: Text("welcome to", style: Theme.of(context).textTheme.subtitle),
      curve: Curves.easeInOut,
    );
  }
}

class HarpyTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: Duration(seconds: 2),
      delay: Duration(milliseconds: 800),
      offset: Offset(0.0, 75.0),
      child: Text("Harpy",
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 64)),
      curve: Curves.easeOutCubic,
    );
  }
}
