import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HarpyScaffold extends StatelessWidget {
  const HarpyScaffold({
    required this.child,
    this.safeAreaBottom = true,
  });

  final Widget child;
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HarpyBackground(
        child: SafeArea(
          bottom: safeAreaBottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: custom app bar
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
