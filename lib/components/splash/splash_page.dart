import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage();

  static const name = 'splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  Future<void> _startTimer() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _showLoading = true);
  }

  @override
  Widget build(BuildContext context) {
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
            duration: kLongAnimationDuration,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
