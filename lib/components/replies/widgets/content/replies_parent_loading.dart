import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';

/// Builds the loading screen for the [RepliesScreen].
class RepliesParentLoading extends StatelessWidget {
  const RepliesParentLoading();

  @override
  Widget build(BuildContext context) {
    return const HarpyScaffold(
      title: 'Replies',
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
