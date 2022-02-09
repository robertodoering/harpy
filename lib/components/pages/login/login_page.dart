import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage();

  static const name = 'login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('login'),
            ElevatedButton(
              onPressed: ref.read(loginProvider).login,
              child: const Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
