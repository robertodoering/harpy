import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the banner image for a user.
///
/// Used as a background for the [UserProfileAppBar].
class UserBanner extends StatelessWidget {
  const UserBanner({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => app<HarpyNavigator>().push(
        HeroDialogRoute<void>(
          onBackgroundTap: app<HarpyNavigator>().maybePop,
          builder: (_) => _FullscreenImage(user: user),
        ),
      ),
      child: Hero(
        tag: user.appropriateUserBannerUrl,
        placeholderBuilder: (_, __, child) => child,
        child: HarpyImage(
          imageUrl: user.appropriateUserBannerUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _FullscreenImage extends StatelessWidget {
  const _FullscreenImage({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return CustomDismissible(
      onDismissed: app<HarpyNavigator>().maybePop,
      child: HarpyMediaGallery.builder(
        itemCount: 1,
        heroTagBuilder: (_) => user.appropriateUserBannerUrl,
        beginBorderRadiusBuilder: (_) => BorderRadius.circular(48),
        builder: (_, __) => HarpyImage(
          imageUrl: user.appropriateUserBannerUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
