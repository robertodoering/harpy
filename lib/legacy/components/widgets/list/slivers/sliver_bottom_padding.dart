import 'package:flutter/material.dart';

class SliverBottomPadding extends StatelessWidget {
  const SliverBottomPadding();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SliverToBoxAdapter(
      child: SizedBox(height: mediaQuery.padding.bottom),
    );
  }
}
