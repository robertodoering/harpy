import 'package:flutter/cupertino.dart';
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
        BlocProvider(
          create: (_) => UserTimelineCubit(
            timelineFilterCubit: context.read(),
            id: user.id,
          ),
        ),
        BlocProvider(create: (_) => LikesTimelineCubit(handle: user.handle)),
      ],
      child: ScrollDirectionListener(
        depth: 2,
        child: HarpySliverTabView(
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
            UserTimeline(user: user),
            const UserMediaTimeline(),
            if (isAuthenticatedUser) const MentionsTimeline(indexInTabView: 2),
            const LikesTimeline(),
          ],
        ),
      ),
    );
  }
}
