import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final isAuthenticatedUser = user.id == authCubit.state.user?.id;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimelineFilterModel.user()),
        BlocProvider(create: (_) => UserTimelineBloc(handle: user.handle)),
        BlocProvider(create: (_) => LikesTimelineBloc(handle: user.handle)),
      ],
      child: ScrollDirectionListener(
        depth: 2,
        // TODO: remove scaffold when removing filter drawer since a scaffold is
        //  already built by the parent
        child: HarpyScaffold(
          endDrawer: const UserTimelineFilterDrawer(),
          body: HarpySliverTabView(
            headerSlivers: [
              UserProfileAppBar(user: user),
              UserProfileHeader(user: user),
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
                const MentionsTimeline(indexInTabView: 2),
              const UserLikesTimeline(),
            ],
          ),
        ),
      ),
    );
  }
}
