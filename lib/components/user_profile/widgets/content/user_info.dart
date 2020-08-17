import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/custom_animated_crossfade.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';

/// Builds the info for a user in the [UserProfileHeader].
///
/// Contains the user avatar, name and a follow / unfollow button.
class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo(this.bloc);

  final UserProfileBloc bloc;

  /// Builds the button to follow / unfollow the user.
  Widget _buildFollowButton(ThemeData theme) {
    return CustomAnimatedCrossFade(
      duration: kShortAnimationDuration,
      firstChild: HarpyButton.raised(
        text: 'Following',
        onTap: () => bloc.add(const UnfollowUserEvent()),
        dense: true,
        backgroundColor: theme.primaryColor,
      ),
      secondChild: HarpyButton.raised(
        text: 'Follow',
        onTap: () => bloc.add(const FollowUserEvent()),
        dense: true,
      ),
      crossFadeState: bloc.user.following
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  /// Builds the display name and screen name for the user.
  Widget _buildUserName(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FittedBox(
          child: Wrap(
            children: <Widget>[
              Text(bloc.user.name, style: theme.textTheme.headline6),
              if (bloc.user.verified) ...<Widget>[
                const Text(' '),
                const Icon(Icons.verified_user, size: 22),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          child: Text(
            '@${bloc.user.screenName}',
            style: theme.textTheme.subtitle1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);

    // hide follow button when the profile of the authenticated user is showing
    // or when the connections have not been requested to determine whether the
    // authenticated user is following this user.
    final bool enableFollow =
        authBloc.authenticatedUser.idStr != bloc.user.idStr &&
            bloc.user.hasConnections;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              // avatar
              CachedCircleAvatar(
                imageUrl: bloc.user.appropriateUserImageUrl,
                radius: 36,
              ),

              const SizedBox(width: 8),

              // user name
              Expanded(child: _buildUserName(theme)),
            ],
          ),
        ),
        if (enableFollow) ...<Widget>[
          const SizedBox(width: 8),
          _buildFollowButton(theme),
        ],
      ],
    );
  }
}
