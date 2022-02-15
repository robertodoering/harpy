import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage();

  static const name = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _loginStarted = false;

  @override
  void initState() {
    super.initState();

    // TODO: potentially open changelog dialog
  }

  Future<void> _startLogin() async {
    HapticFeedback.mediumImpact().ignore();
    setState(() => _loginStarted = true);

    await Future<void>.delayed(kLongAnimationDuration);
    await ref.read(loginProvider).login();

    setState(() => _loginStarted = false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final authenticationState = ref.watch(authenticationStateProvider);

    return HarpyScaffold(
      safeArea: true,
      child: authenticationState.when(
        awaitingAuthentication: () => const Center(
          child: CircularProgressIndicator(),
        ),
        authenticated: (_) => const SizedBox(),
        unauthenticated: () => AnimatedSlide(
          duration: kLongAnimationDuration,
          curve: Curves.easeInCubic,
          offset: _loginStarted ? const Offset(0, -1) : Offset.zero,
          child: Stack(
            children: [
              const _AboutButton(),
              Column(
                children: [
                  Expanded(
                    child: OverflowBox(
                      maxHeight: mediaQuery.size.height,
                      child: Column(
                        children: [
                          const Spacer(),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: mediaQuery.size.height * .5,
                            ),
                            child: Column(
                              children: const [
                                Expanded(child: _HarpyTitle()),
                                Expanded(child: _HarpyLogo()),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _LoginButton(onTap: _startLogin),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutButton extends ConsumerWidget {
  const _AboutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () => Navigator.of(context).push(
          HarpyPageRoute<void>(
            builder: (_) => const AboutPage(),
          ),
        ),
      ),
    );
  }
}

class _HarpyTitle extends StatelessWidget {
  const _HarpyTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 2 / 3,
      child: ImmediateSlideAnimation(
        duration: const Duration(seconds: 3),
        curve: Curves.easeOutCubic,
        begin: const Offset(0, .5),
        child: FlareAnimation.harpyTitle(
          alignment: Alignment.bottomCenter,
          animation: 'show',
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}

class _HarpyLogo extends StatelessWidget {
  const _HarpyLogo();

  @override
  Widget build(BuildContext context) {
    return const ImmediateSlideAnimation(
      delay: Duration(milliseconds: 800),
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeOut,
      begin: Offset(0, .25),
      child: FlareAnimation.harpyLogo(animation: 'show'),
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
    return ImmediateScaleAnimation(
      delay: const Duration(milliseconds: 2200),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      begin: 0,
      child: ElevatedButton(
        onPressed: onTap,
        child: const Text('login with Twitter'),
      ),
    );
  }
}
