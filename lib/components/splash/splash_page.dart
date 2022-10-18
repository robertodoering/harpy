import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({
    this.redirect,
  });

  /// The name of the route the user should be redirected to after
  /// initialization.
  final String? redirect;

  static const name = 'splash';
  static const path = '/splash';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();

    // start app initialization
    ref.read(applicationProvider).initialize(redirect: widget.redirect);

    Timer(const Duration(seconds: 2), _timerCallback);
  }

  Future<void> _timerCallback() async {
    if (mounted) setState(() => _showLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return HarpyBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height / 2,
            child: const FractionallySizedBox(
              widthFactor: 0.66,
              child: FlareAnimation.harpyLogo(animation: 'show'),
            ),
          ),
          AnimatedOpacity(
            opacity: _showLoading ? 1 : 0,
            duration: theme.animation.long,
            curve: Curves.easeInOut,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
