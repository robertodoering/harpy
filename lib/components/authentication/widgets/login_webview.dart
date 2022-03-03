import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class LoginWebview extends StatelessWidget {
  const LoginWebview({
    required this.webview,
  });

  final Widget webview;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      safeArea: true,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          const HarpySliverAppBar(title: Text('login')),
          SliverFillRemaining(child: webview),
        ],
      ),
    );
  }
}
