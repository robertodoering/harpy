import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_tweet_list.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/user_profile_model.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  Widget _buildTweetList(BuildContext context, UserProfileModel model) {
    final banner =
        model.user.profileBannerUrl ?? model.user.profileBackgroundImageUrl;

    final harpyTheme = HarpyTheme.of(context);

    return FadingNestedScaffold(
      title: model.user.name,
      background: banner == null
          ? Container(color: harpyTheme.backgroundColors.first)
          : CachedNetworkImage(
              imageUrl: banner,
              fit: BoxFit.cover,
            ),
      body: UserProfileTweetList(),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    Color color,
  ) {
    return FadingNestedScaffold(
      background: Container(color: color),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(
    BuildContext context,
    Color color,
  ) {
    return FadingNestedScaffold(
      background: Container(color: color),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: Text("Error loading user")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = UserProfileModel.of(context);
    final color = HarpyTheme.of(context).backgroundColors.first;

    if (model.loadingUser) {
      return _buildLoading(context, color);
    } else if (model.user != null) {
      return _buildTweetList(context, model);
    } else {
      // if we are not loading the user and user is null assume there was an
      // error while loading the user
      return _buildError(context, color);
    }
  }
}
