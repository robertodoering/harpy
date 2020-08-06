import 'package:flutter/material.dart';
import 'package:harpy/components/common/harpy_scaffold.dart';

/// Builds the loading screen for the [UserProfileScreen].
class UserProfileLoading extends StatelessWidget {
  const UserProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const HarpyScaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
