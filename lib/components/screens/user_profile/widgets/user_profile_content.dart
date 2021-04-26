import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    @required this.bloc,
  });

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc = context.watch<AuthenticationBloc>();

    final bool isAuthenticatedUser =
        bloc.user.idStr == authBloc.authenticatedUser.idStr;

    final String screenName = bloc.user?.screenName;

    return ChangeNotifierProvider<TimelineFilterModel>(
      create: (_) => TimelineFilterModel.user(),
      child: BlocProvider<UserTimelineBloc>(
        create: (_) => UserTimelineBloc(screenName: screenName),
        child: BlocProvider<LikesTimelineBloc>(
          create: (_) => LikesTimelineBloc(screenName: screenName),
          child: ScrollDirectionListener(
            depth: 2,
            child: HarpyScaffold(
              endDrawer: const UserTimelineFilterDrawer(),
              endDrawerEnableOpenDragGesture: false,
              body: HarpySliverTabView(
                headerSlivers: const <Widget>[
                  UserProfileAppBar(),
                  UserProfileHeader(),
                ],
                tabs: <Widget>[
                  const HarpyTab(
                    icon: Icon(CupertinoIcons.time),
                    text: Text('timeline'),
                  ),
                  const HarpyTab(
                    icon: Icon(CupertinoIcons.photo),
                    text: Text('media'),
                  ),
                  if (isAuthenticatedUser)
                    const HarpyTab(
                      icon: Icon(CupertinoIcons.at),
                      text: Text('mentions'),
                    ),
                  const HarpyTab(
                    icon: Icon(CupertinoIcons.heart_solid),
                    text: Text('likes'),
                  ),
                ],
                children: <Widget>[
                  const UserTimeline(),
                  const UserMediaTimeline(),
                  if (isAuthenticatedUser)
                    const MentionsTimeline(
                      indexInTabView: 2,
                    ),
                  const UserLikesTimeline(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
