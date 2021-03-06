import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/timeline/user_timeline/widgets/user_timeline.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/widgets/content/user_timeline_filter_drawer.dart';
import 'package:provider/provider.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    @required this.bloc,
  });

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final String screenName = bloc.user?.screenName;

    return ScrollDirectionListener(
      child: ChangeNotifierProvider<TimelineFilterModel>(
        create: (_) => TimelineFilterModel.user(),
        child: BlocProvider<UserTimelineBloc>(
          create: (_) => UserTimelineBloc(screenName: screenName),
          child: const HarpyScaffold(
            endDrawer: UserTimelineFilterDrawer(),
            body: UserTimeline(),
          ),
        ),
      ),
    );
  }
}
