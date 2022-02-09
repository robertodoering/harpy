import 'package:flutter/material.dart';

class LoginWebview extends StatelessWidget {
  const LoginWebview({
    required this.webview,
  });

  final Widget webview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('login')),
      body: webview,
    );
  }
}
