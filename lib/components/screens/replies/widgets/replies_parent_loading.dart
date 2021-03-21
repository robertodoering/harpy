import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds the loading screen for the [RepliesScreen].
class RepliesParentLoading extends StatelessWidget {
  const RepliesParentLoading();

  @override
  Widget build(BuildContext context) {
    return const HarpyScaffold(
      title: 'replies',
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
