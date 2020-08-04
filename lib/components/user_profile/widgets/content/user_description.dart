import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the description for a user in the [UserProfileHeader].
class UserProfileDescription extends StatelessWidget {
  const UserProfileDescription(this.bloc);

  final UserProfileBloc bloc;

  void _onUserMentionTap(UserMention userMention) {
    if (userMention.screenName != null) {
      app<HarpyNavigator>().pushUserProfile(screenName: userMention.screenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TwitterText(
      bloc.user.description,
      entities: bloc.userEntities,
      entityColor: theme.accentColor,
      onUserMentionTap: _onUserMentionTap,
    );
  }
}
