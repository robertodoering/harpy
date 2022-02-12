import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HarpyScaffold extends StatelessWidget {
  const HarpyScaffold({
    required this.child,
    this.safeArea = false,
  });

  final Widget child;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HarpyBackground(
        child: SafeArea(
          top: safeArea,
          bottom: safeArea,
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
