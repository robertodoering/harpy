import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/models/user_profile_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/widgets/shared/cache_provider.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/tweet/tweet_list.dart';
import 'package:harpy/widgets/shared/user_profile_header.dart';
import 'package:scoped_model/scoped_model.dart';

/// The user profile screen to show information and the user timeline of the
/// [user].
///
/// If [user] is `null` [userId] mustn't be `null` and is used to load the
/// [User].
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    this.user,
    this.userId,
  }) : assert(user != null || userId != null);

  final User user;
  final String userId;

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileModel userProfileModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    userProfileModel ??= UserProfileModel(
      user: widget.user,
      userId: widget.userId,
      userService: serviceProvider.data.userService,
      userCache: serviceProvider.data.userCache,
    );

    return ScopedModel<UserProfileModel>(
      model: userProfileModel,
      child: ScopedModelDescendant<UserProfileModel>(
        builder: (context, _, model) {
          return _buildScreen(context, model);
        },
      ),
    );
  }

  Widget _buildScreen(BuildContext context, UserProfileModel model) {
    if (model.loadingUser) {
      return _buildLoading(context);
    } else if (model.user != null) {
      return _buildTweetList(context, model);
    } else {
      return _buildError(context);
    }
  }

  Widget _buildTweetList(BuildContext context, UserProfileModel model) {
    return FadingNestedScaffold(
      title: model.user.name,
      background: CachedNetworkImage(
        imageUrl: model.user.profile_banner_url ??
            model.user.profileBackgroundImageUrl,
        fit: BoxFit.cover,
      ),
      body: _UserProfileTweetList(),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return FadingNestedScaffold(
      background: Container(color: Theme.of(context).primaryColor),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context) {
    return FadingNestedScaffold(
      background: Container(color: Theme.of(context).primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("Error loading user")),
      ),
    );
  }
}

class _UserProfileTweetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);
    final userProfileModel = UserProfileModel.of(context);

    return ScopedModel<UserTimelineModel>(
      model: UserTimelineModel(
        userId: "${userProfileModel.user.id}",
        tweetService: serviceProvider.data.tweetService,
        userTimelineCache: serviceProvider.data.userTimelineCache,
      ),
      child: CacheProvider(
        homeTimelineCache: serviceProvider.data.homeTimelineCache,
        userTimelineCache: serviceProvider.data.userTimelineCache,
        child: TweetList<UserTimelineModel>(
          leading: UserProfileHeader(user: userProfileModel.user),
        ),
      ),
    );
  }
}
