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
class UserProfileContent extends StatefulWidget {
  const UserProfileContent();

  @override
  _UserProfileContentState createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  Widget _buildSliverAppBar(UserProfileBloc bloc) {
    final bool _hasUser = bloc.state is InitializedUserState;

    return HarpySliverAppBar(
      title: bloc.user?.name ?? '',
      stretch: true,
      pinned: true,
      background: _hasUser ? UserBanner(bloc) : null,
      scrollController: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileBloc bloc = UserProfileBloc.of(context);

    final String screenName = bloc.user?.screenName;

    return PrimaryScrollController(
      controller: _controller,
      child: BlocProvider<UserTimelineBloc>(
        create: (BuildContext context) => UserTimelineBloc(
          screenName: screenName,
        ),
        child: HarpyScaffold(
          body: TweetTimeline<UserTimelineBloc>(
            headerSlivers: <Widget>[
              _buildSliverAppBar(bloc),
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
      ),
    );
  }
}
