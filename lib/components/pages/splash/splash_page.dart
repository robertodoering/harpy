import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage();

  static const name = 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HarpyScaffold(
      child: Center(child: Text('splash')),
    );
  }
}
