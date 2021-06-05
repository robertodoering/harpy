import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds the description for a user in the [UserProfileHeader].
class UserProfileDescription extends StatelessWidget {
  const UserProfileDescription(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return TwitterText(
      bloc.user!.description!,
      entities: bloc.user!.userDescriptionEntities,
    );
  }
}
