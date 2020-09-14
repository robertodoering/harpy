import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/following/bloc/following_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CachedCircleAvatar(
          imageUrl: user.profileImageUrlHttps,
        ),
        title: Text(user.name),
      ),
    );
  }
}
