import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomePage extends ConsumerWidget {
  const HomePage();

  static const name = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('home'),
            ElevatedButton(
              onPressed: ref.read(logoutProvider).logout,
              child: const Text('logout'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(messageServiceProvider).showSnackbar(
                      const SnackBar(content: Text('test snackbar')),
                    );
              },
              child: const Text('snack'),
            ),
          ],
        ),
      ),
    );
  }
}
