import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/translation_button.dart';
import 'package:harpy/components/common/misc/followers_count.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/content/user_additional_info.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description_translation.dart';
import 'package:harpy/components/user_profile/widgets/content/user_info.dart';

/// Builds the header for the [UserProfileScreen].
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: DefaultEdgeInsets.only(left: true, right: true, top: true),
      elevation: 0,
      child: Padding(
        padding: DefaultEdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserProfileInfo(bloc),
            defaultSmallVerticalSpacer,
            if (bloc.user.hasDescription) ...<Widget>[
              UserProfileDescription(bloc),
              UserProfileDescriptionTranslation(bloc),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[UserDescriptionTranslationButton(bloc)],
              ),
              defaultSmallVerticalSpacer,
            ],
            UserProfileAdditionalInfo(bloc),
            FollowersCount(bloc.user),
          ],
        ),
      ),
    );
  }
}
