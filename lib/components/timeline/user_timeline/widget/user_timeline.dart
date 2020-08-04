import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline({
    @required this.screenName,
  });

  /// The screen name of the user that is used to load the timeline.
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserTimelineBloc>(
      create: (BuildContext context) => UserTimelineBloc(
        screenName: screenName,
      ),
      child: TweetTimeline<UserTimelineBloc>(
        // todo
        onRefresh: (_) async {},
        onLoadMore: (_) async {},
      ),
    );
  }
}
