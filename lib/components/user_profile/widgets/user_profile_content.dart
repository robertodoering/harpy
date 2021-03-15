import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/sliver_tab_view/harpy_sliver_tab_view.dart';
import 'package:harpy/components/common/sliver_tab_view/harpy_tab.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/likes_timeline/bloc/likes_timeline_bloc.dart';
import 'package:harpy/components/timeline/likes_timeline/widgets/likes_timeline.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/timeline/user_timeline/widgets/user_timeline.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/user_media_timeline/widgets/user_media_timeline.dart';
import 'package:harpy/components/user_profile/widgets/content/user_timeline_filter_drawer.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';
import 'package:provider/provider.dart';

import 'content/user_profile_app_bar.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    @required this.bloc,
  });

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final String screenName = bloc.user?.screenName;

    return ChangeNotifierProvider<TimelineFilterModel>(
      create: (_) => TimelineFilterModel.user(),
      child: BlocProvider<UserTimelineBloc>(
        create: (_) => UserTimelineBloc(screenName: screenName),
        child: BlocProvider<LikesTimelineBloc>(
          create: (_) => LikesTimelineBloc(screenName: screenName),
          child: ScrollDirectionListener(
            child: HarpyScaffold(
              endDrawer: const UserTimelineFilterDrawer(),
              endDrawerEnableOpenDragGesture: false,
              body: HarpySliverTabView(
                headerSlivers: const <Widget>[
                  UserProfileAppBar(),
                  UserProfileHeader(),
                ],
                tabs: const <Widget>[
                  HarpyTab(
                    icon: Icon(CupertinoIcons.time),
                    text: Text('timeline'),
                  ),
                  HarpyTab(
                    icon: Icon(CupertinoIcons.photo),
                    text: Text('media'),
                  ),
                  HarpyTab(
                    icon: Icon(CupertinoIcons.heart_solid),
                    text: Text('likes'),
                  ),
                ],
                children: const <Widget>[
                  UserTimeline(),
                  UserMediaTimeline(),
                  LikesTimeline(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
