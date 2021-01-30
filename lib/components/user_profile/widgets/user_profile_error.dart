import 'package:flutter/material.dart';
import 'package:harpy/components/common/api/loading_data_error.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Builds an error message for the [UserProfileScreen].
class UserProfileError extends StatelessWidget {
  const UserProfileError(
    this.bloc, {
    this.user,
    this.screenName,
  });

  final UserProfileBloc bloc;

  final UserData user;

  final String screenName;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: '',
      body: LoadingDataError(
        message: const Text('Error loading user'),
        onTap: () => bloc.add(InitializeUserEvent(
          user: user,
          screenName: screenName,
        )),
      ),
    );
  }
}
