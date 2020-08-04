import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/fading_nested_scaffold.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return FadingNestedScaffold(
      title: bloc.user.name,
      background: GestureDetector(
        // todo: open image gallery
        onTap: () {},
        child: CachedNetworkImage(
          imageUrl: bloc.user.profileBannerUrl,
          fit: BoxFit.cover,
        ),
      ),
      body: UserProfileHeader(bloc),
    );
  }
}
