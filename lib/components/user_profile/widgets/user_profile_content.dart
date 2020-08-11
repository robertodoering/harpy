import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/misc/fading_nested_scaffold.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/timeline/user_timeline/widget/user_timeline.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent(this.bloc);

  final UserProfileBloc bloc;

  /// Builds the profile banner for a [HeroDialogRoute] when the user taps on
  /// the banner.
  Widget _buildDialogImage() {
    final String url = bloc.user.appropriateUserBannerUrl;

    return CustomDismissible(
      onDismissed: () => app<HarpyNavigator>().state.maybePop(),
      child: Center(
        child: Hero(
          tag: url,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarBackground() {
    final String url = bloc.user.appropriateUserBannerUrl;

    if (bloc.user.hasBanner) {
      return GestureDetector(
        onTap: () {
          app<HarpyNavigator>().pushRoute(HeroDialogRoute<void>(
            onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
            builder: (BuildContext context) => _buildDialogImage(),
          ));
        },
        child: Hero(
          tag: url,
          placeholderBuilder:
              (BuildContext context, Size heroSize, Widget child) => child,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    // limit the app bar extended height
    final double appBarHeight = min(200, mediaQuery.size.height * .25);

    return FadingNestedScaffold(
      title: bloc.user.name,
      alwaysShowTitle: !bloc.user.hasBanner,
      background: _buildAppBarBackground(),
      header: <Widget>[
        UserProfileHeader(bloc),
      ],
      body: UserTimeline(screenName: bloc.user.screenName),
      expandedHeight: appBarHeight,
    );
  }
}
