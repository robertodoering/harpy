import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds the header for the [UserProfileScreen].
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final bloc = context.watch<UserProfileBloc>();

    return SliverToBoxAdapter(
      child: Card(
        margin: config.edgeInsetsOnly(left: true, right: true, top: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            defaultVerticalSpacer,
            Padding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              child: UserProfileInfo(bloc),
            ),
            defaultSmallVerticalSpacer,
            if (bloc.user!.hasDescription) ...<Widget>[
              Padding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                child: UserProfileDescription(bloc),
              ),
              Padding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                child: UserProfileDescriptionTranslation(bloc),
              ),
              defaultSmallVerticalSpacer,
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: config.edgeInsetsOnly(left: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserProfileAdditionalInfo(bloc),
                        FollowersCount(bloc.user!),
                        defaultVerticalSpacer,
                      ],
                    ),
                  ),
                ),
                if (bloc.user!.hasDescription)
                  UserDescriptionTranslationButton(bloc),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
