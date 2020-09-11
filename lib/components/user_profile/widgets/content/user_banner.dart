import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the user banner image as the background for a [HarpySliverAppBar].
class UserBanner extends StatelessWidget {
  const UserBanner(this.bloc);

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

  @override
  Widget build(BuildContext context) {
    if (bloc.user?.hasBanner == true) {
      final String url = bloc.user.appropriateUserBannerUrl;

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
}
