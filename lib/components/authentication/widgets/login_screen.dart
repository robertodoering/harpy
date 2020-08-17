import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';
import 'package:harpy/components/authentication/widgets/headlines.dart';
import 'package:harpy/components/common/animations/explicit/bounce_in_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_in_animation.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/misc/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  static const String route = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<SlideAnimationState> _slideLoginKey =
      GlobalKey<SlideAnimationState>();

  Future<void> _startLogin() async {
    await _slideLoginKey.currentState.forward();

    AuthenticationBloc.of(context).add(const LoginEvent());
  }

  Widget _buildText() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: SecondaryHeadline('welcome to'),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    final Color color = theme.textTheme.bodyText2.color;

    return FractionallySizedBox(
      widthFactor: 2 / 3,
      child: SlideInAnimation(
        offset: const Offset(0, 20),
        duration: const Duration(seconds: 3),
        delay: const Duration(milliseconds: 800),
        child: FlareActor(
          'assets/flare/harpy_title.flr',
          alignment: Alignment.bottomCenter,
          animation: 'show',
          color: color,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const SlideInAnimation(
      duration: Duration(seconds: 3),
      offset: Offset(0, 20),
      delay: Duration(milliseconds: 800),
      child: FlareActor(
        'assets/flare/harpy_logo.flr',
        animation: 'show',
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _LoginButton(onTap: _startLogin),
        const SizedBox(height: 8),
        const _CreateAccountButton(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLoginScreen(ThemeData theme) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return SlideAnimation(
      key: _slideLoginKey,
      endPosition: Offset(0, -mediaQuery.size.height),
      child: Column(
        children: <Widget>[
          Expanded(child: _buildText()),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Expanded(child: _buildTitle(theme)),
                Expanded(child: _buildLogo()),
              ],
            ),
          ),
          Expanded(child: _buildButtons()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        final ThemeData theme = Theme.of(context);

        return HarpyBackground(
          child: state is AwaitingAuthenticationState
              ? const Center(child: CircularProgressIndicator())
              : _buildLoginScreen(theme),
        );
      },
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
        text: 'Login with Twitter',
        onTap: onTap,
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 3000),
      child: HarpyButton.flat(
        text: 'Create an account',
        onTap: () => launchUrl('https://twitter.com/signup'),
      ),
    );
  }
}
