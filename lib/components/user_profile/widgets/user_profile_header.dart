import 'package:flutter/material.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description.dart';
import 'package:harpy/components/user_profile/widgets/content/user_info.dart';

/// Builds the header for the [UserProfileScreen].
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserProfileInfo(bloc),
          if (bloc.user.hasDescription) UserProfileDescription(bloc),
        ],
      ),
    );
  }
}
