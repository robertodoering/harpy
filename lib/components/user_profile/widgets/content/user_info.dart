import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/image_gallery/image_gallery.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/custom_animated_crossfade.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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
        text: const Text('Following'),
        onTap: () => bloc.add(const UnfollowUserEvent()),
        dense: true,
        backgroundColor: theme.primaryColor,
      ),
      secondChild: HarpyButton.raised(
        text: const Text('Follow'),
        onTap: () => bloc.add(const FollowUserEvent()),
        dense: true,
      ),
      crossFadeState: bloc.user.following
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  /// The flight shuttle builder for the avatar hero animation.
  ///
  /// Used to animate the border radius during the animation.
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;

    // animate the border radius during the hero flight animation
    final BorderRadiusTween tween = BorderRadiusTween(
      begin: BorderRadius.circular(48),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) => ClipRRect(
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  /// Builds the user's avatar that opens it in fullscreen on tap.
  ///
  /// We use the original sized user avatar for both the circle avatar and
  /// fullscreen image to allow for a smooth hero animation (That is not
  /// possible if the full screen image has to be loaded first).
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        app<HarpyNavigator>().pushRoute(
          HeroDialogRoute<void>(
            onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
            builder: (BuildContext context) {
              return ImageGallery(
                urls: <String>[bloc.user.originalUserImageUrl],
                heroTags: <Object>[bloc.user],
                flightShuttleBuilder: _flightShuttleBuilder,
              );
            },
          ),
        );
      },
      child: CachedCircleAvatar(
        imageUrl: bloc.user.originalUserImageUrl,
        radius: 36,
        heroTag: bloc.user,
      ),
    );
  }

  /// Builds the name with the verified icon and the @username.
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
              _buildAvatar(),
              defaultHorizontalSpacer,
              Expanded(child: _buildUserName(theme)),
            ],
          ),
        ),
        if (enableFollow) ...<Widget>[
          defaultHorizontalSpacer,
          _buildFollowButton(theme),
        ],
      ],
    );
  }
}
