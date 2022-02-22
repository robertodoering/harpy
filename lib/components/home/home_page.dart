import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomePage extends ConsumerWidget {
  const HomePage();

  static const name = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const WillPopHarpy(
      child: HarpyScaffold(
        child: ScrollDirectionListener(
          depth: 1,
          child: HomeTabView(),
        ),
      ),
    );
  }
}
