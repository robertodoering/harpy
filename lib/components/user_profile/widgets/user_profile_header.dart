import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/translation_button.dart';
import 'package:harpy/components/common/misc/followers_count.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/content/user_additional_info.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description.dart';
import 'package:harpy/components/user_profile/widgets/content/user_description_translation.dart';
import 'package:harpy/components/user_profile/widgets/content/user_info.dart';
import 'package:provider/provider.dart';

/// Builds the header for the [UserProfileScreen].
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader();

  @override
  Widget build(BuildContext context) {
    final UserProfileBloc bloc = context.watch<UserProfileBloc>();

    return SliverToBoxAdapter(
      child: Card(
        margin: DefaultEdgeInsets.only(left: true, right: true, top: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            defaultVerticalSpacer,
            Padding(
              padding: DefaultEdgeInsets.symmetric(horizontal: true),
              child: UserProfileInfo(bloc),
            ),
            defaultSmallVerticalSpacer,
            if (bloc.user.hasDescription) ...<Widget>[
              Padding(
                padding: DefaultEdgeInsets.symmetric(horizontal: true),
                child: UserProfileDescription(bloc),
              ),
              Padding(
                padding: DefaultEdgeInsets.symmetric(horizontal: true),
                child: UserProfileDescriptionTranslation(bloc),
              ),
              defaultSmallVerticalSpacer,
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: DefaultEdgeInsets.only(left: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserProfileAdditionalInfo(bloc),
                        FollowersCount(bloc.user),
                        defaultVerticalSpacer,
                      ],
                    ),
                  ),
                ),
                if (bloc.user.hasDescription)
                  UserDescriptionTranslationButton(bloc),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
