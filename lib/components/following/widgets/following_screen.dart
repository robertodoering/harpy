import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/following/bloc/following_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
    @required this.userId,
  });

  final String userId;

  static const String route = 'following';

  Widget _itemBuilder(int index, FollowingBloc bloc) {
    return UserCard(bloc.users[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowingBloc>(
      create: (BuildContext context) => FollowingBloc(userId: userId),
      child: BlocBuilder<FollowingBloc, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          final FollowingBloc bloc = FollowingBloc.of(context);

          return HarpyScaffold(
            title: 'Following',
            body: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: bloc.users.length,
              itemBuilder: (BuildContext context, int index) =>
                  _itemBuilder(index, bloc),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(this.user);

  final UserData user;

  void _onUserTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context).settings,
      screenName: user.screenName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        isThreeLine: user.hasDescription,
        leading: CachedCircleAvatar(
          imageUrl: user.profileImageUrlHttps,
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('@${user.screenName}'),
            if (user.hasDescription)
              TwitterText(
                user.description,
                entities: user.userDescriptionEntities,
                entityColor: theme.accentColor,
                maxLines: 1,
              ),
          ],
        ),
        onTap: () => _onUserTap(context),
      ),
    );
  }
}
