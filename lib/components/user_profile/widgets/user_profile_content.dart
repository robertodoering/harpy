import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_event.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/components/user_profile/widgets/content/user_banner.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    @required this.bloc,
  });

  final UserProfileBloc bloc;

  Widget _buildSliverAppBar() {
    final bool _hasUser = bloc.state is InitializedUserState;

    return HarpySliverAppBar(
      title: bloc.user?.name ?? '',
      stretch: true,
      pinned: true,
      background: _hasUser ? UserBanner(bloc) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String screenName = bloc.user?.screenName;

    return BlocProvider<UserTimelineBloc>(
      create: (BuildContext context) => UserTimelineBloc(
        screenName: screenName,
      ),
      child: HarpyScaffold(
        body: TweetTimeline<UserTimelineBloc>(
          headerSlivers: <Widget>[
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: UserProfileHeader(bloc)),
          ],
          onRefresh: (UserTimelineBloc timelineBloc) {
            timelineBloc.add(UpdateUserTimelineEvent(screenName: screenName));
            return timelineBloc.updateTimelineCompleter.future;
          },
          onLoadMore: (UserTimelineBloc timelineBloc) {
            timelineBloc
                .add(RequestMoreUserTimelineEvent(screenName: screenName));
            return timelineBloc.requestMoreCompleter.future;
          },
        ),
      ),
    );
  }
}
