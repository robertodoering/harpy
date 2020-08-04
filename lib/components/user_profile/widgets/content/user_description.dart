import 'package:flutter/material.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';

/// Builds the description for a user in the [UserProfileHeader].
class UserProfileDescription extends StatelessWidget {
  const UserProfileDescription(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return TwitterText(
      bloc.user.description,
      // todo: user entities for twitter text
      // entities: bloc.user.entities.asEntities,
    );
  }
}
