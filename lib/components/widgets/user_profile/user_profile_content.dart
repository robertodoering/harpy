import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_tweet_list.dart';
import 'package:harpy/models/user_profile_model.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  Widget _buildTweetList(BuildContext context, UserProfileModel model) {
    return FadingNestedScaffold(
      title: model.user.name,
      background: CachedNetworkImage(
        imageUrl:
            model.user.profileBannerUrl ?? model.user.profileBackgroundImageUrl,
        fit: BoxFit.cover,
      ),
      body: UserProfileTweetList(),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return FadingNestedScaffold(
      background: HarpyBackground(),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context) {
    return FadingNestedScaffold(
      background: HarpyBackground(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("Error loading user")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = UserProfileModel.of(context);

    if (model.loadingUser) {
      return _buildLoading(context);
    } else if (model.user != null) {
      return _buildTweetList(context, model);
    } else {
      // if we are not loading the user and user is null assume there was an
      // error while loading the user
      return _buildError(context);
    }
  }
}
