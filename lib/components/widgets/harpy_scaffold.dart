import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

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
        child: Unfocus(
          child: SafeArea(
            top: safeArea,
            bottom: safeArea,
            child: SizedBox(
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
