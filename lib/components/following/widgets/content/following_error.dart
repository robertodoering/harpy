import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/following/bloc/following_bloc.dart';
import 'package:harpy/components/following/bloc/following_event.dart';

/// Builds an error message for the [FollowingScreen].
class LoadingFollowingUsersError extends StatelessWidget {
  const LoadingFollowingUsersError(this.bloc);

  final FollowingBloc bloc;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Error loading following users',
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          HarpyButton.flat(
            dense: true,
            text: 'retry',
            onTap: () => bloc.add(const LoadFollowingUsers()),
          ),
        ],
      ),
    );
  }
}
