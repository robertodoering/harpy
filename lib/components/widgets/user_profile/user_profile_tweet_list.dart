import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/tweet/tweet_timeline.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_header.dart';
import 'package:harpy/models/user_profile_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:provider/provider.dart';

/// Wraps the [TweetTimeline] for the [UserTimelineModel].
class UserProfileTweetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProfileModel = UserProfileModel.of(context);

    return ChangeNotifierProvider<UserTimelineModel>(
      builder: (_) => UserTimelineModel(
        userId: userProfileModel.user.id,
      ),
      child: TweetTimeline<UserTimelineModel>(
        leading: UserProfileHeader(),
      ),
    );
  }
}
