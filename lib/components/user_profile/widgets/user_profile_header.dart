import 'package:flutter/material.dart';
import 'package:harpy/components/common/followers_count.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/content/user_additional_info.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description.dart';
import 'package:harpy/components/user_profile/widgets/content/user_info.dart';

/// Builds the header for the [UserProfileScreen].
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      color: theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(.1)
          : Colors.black.withOpacity(.1),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserProfileInfo(bloc),
            const SizedBox(height: 8),
            if (bloc.user.hasDescription) ...<Widget>[
              UserProfileDescription(bloc),
              const SizedBox(height: 8),
            ],
            UserProfileAdditionalInfo(bloc),
            FollowersCount(bloc.user),
          ],
        ),
      ),
    );
  }
}
