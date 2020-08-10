import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
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
    final ThemeData theme = Theme.of(context);

    return HarpyScaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Error loading user',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            HarpyButton.flat(
              dense: true,
              text: 'retry',
              onTap: () => bloc.add(InitializeUserEvent(
                user: user,
                screenName: screenName,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
