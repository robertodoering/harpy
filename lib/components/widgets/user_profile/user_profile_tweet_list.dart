import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/cache_provider.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/components/widgets/tweet/tweet_list.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_header.dart';
import 'package:harpy/models/user_profile_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:provider/provider.dart';

/// Wraps the [TweetList] for the [UserTimelineModel].
class UserProfileTweetList extends StatefulWidget {
  @override
  _UserProfileTweetListState createState() => _UserProfileTweetListState();
}

class _UserProfileTweetListState extends State<UserProfileTweetList> {
  UserTimelineModel model;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);
    final userProfileModel = UserProfileModel.of(context);

    model ??= UserTimelineModel(
      userId: "${userProfileModel.user.id}",
      tweetService: serviceProvider.data.tweetService,
      userTimelineCache: serviceProvider.data.userTimelineCache,
    );

    return ChangeNotifierProvider<UserTimelineModel>(
      builder: (_) => model,
      child: CacheProvider(
        homeTimelineCache: serviceProvider.data.homeTimelineCache,
        userTimelineCache: serviceProvider.data.userTimelineCache,
        child: TweetList<UserTimelineModel>(
          leading: UserProfileHeader(),
        ),
      ),
    );
  }
}
