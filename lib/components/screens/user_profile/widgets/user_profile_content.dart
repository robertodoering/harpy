import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the content for the [UserProfileScreen].
class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    required this.bloc,
  });

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();

    final isAuthenticatedUser = bloc.user!.id == authCubit.state.user?.id;

    final screenName = bloc.user?.handle;

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
              body: HarpySliverTabView(
                headerSlivers: const [
                  UserProfileAppBar(),
                  UserProfileHeader(),
                ],
                tabs: [
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
                children: [
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
