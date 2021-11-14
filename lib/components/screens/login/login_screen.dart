import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:pedantic/pedantic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  static const route = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<SlideAnimationState> _slideLoginKey =
      GlobalKey<SlideAnimationState>();

  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);
  }

  Future<void> _startLogin(AuthenticationCubit authCubit) async {
    unawaited(HapticFeedback.mediumImpact());
    await _slideLoginKey.currentState!.forward();

    unawaited(authCubit.login());
  }

  Widget _buildAboutButton(ThemeData theme) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: HarpyButton.flat(
          icon: Icon(
            CupertinoIcons.info,
            color: theme.textTheme.bodyText1!.color!.withOpacity(.8),
          ),
          padding: const EdgeInsets.all(16),
          onTap: () => app<HarpyNavigator>().pushNamed(AboutScreen.route),
        ),
      ),
    );
  }

  Widget _buildText(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeAnimation(
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
        child: SlideInAnimation(
          offset: const Offset(0, 50),
          curve: Curves.easeOut,
          duration: const Duration(seconds: 1),
          child: Text(
            'welcome to',
            style: theme.textTheme.headline4,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    final color = theme.textTheme.bodyText2!.color;

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

  Widget _buildButtons(AuthenticationCubit authCubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _LoginButton(
          onTap: () => _startLogin(authCubit),
        ),
      ],
    );
  }

  Widget _buildLoginScreen(ThemeData theme, AuthenticationCubit authCubit) {
    final mediaQuery = MediaQuery.of(context);

    return SlideAnimation(
      key: _slideLoginKey,
      endPosition: Offset(0, -mediaQuery.size.height),
      child: Stack(
        children: [
          _buildAboutButton(theme),
          Column(
            children: [
              Expanded(child: _buildText(theme)),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(child: _buildTitle(theme)),
                    Expanded(child: _buildLogo()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildButtons(authCubit)),
              const SizedBox(height: 32),
              SizedBox(height: mediaQuery.padding.bottom),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.watch<AuthenticationCubit>();

    return HarpyBackground(
      child: authCubit.state.isAwaitingAuthentication
          ? const Center(child: CircularProgressIndicator())
          : _buildLoginScreen(theme, authCubit),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BounceInAnimation(
      delay: const Duration(milliseconds: 2800),
      child: HarpyButton.raised(
        text: const Text('login with twitter'),
        onTap: onTap,
      ),
    );
  }
}
