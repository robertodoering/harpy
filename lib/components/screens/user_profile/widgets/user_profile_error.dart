import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds an error message for the [UserProfileScreen].
class UserProfileError extends StatelessWidget {
  const UserProfileError(
    this.bloc, {
    this.user,
    this.screenName,
  });

  final UserProfileBloc bloc;

  final UserData? user;

  final String? screenName;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: '',
      body: LoadingDataError(
        message: const Text('error loading user'),
        onRetry: () => bloc.add(InitializeUserEvent(
          user: user,
          handle: screenName,
        )),
      ),
    );
  }
}
