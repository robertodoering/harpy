import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
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
                  UserLikesTimeline(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
