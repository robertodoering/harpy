import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/user_profile_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/load_more_list.dart';
import 'package:harpy/components/widgets/shared/loading_tile.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/user_search/user_list_tile.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/user_followers_model.dart';
import 'package:harpy/models/user_following_model.dart';
import 'package:provider/provider.dart';

/// The following or follower type to determine what list of users to show in
/// the [FollowingFollowerScreen].
enum FollowingFollowerType {
  following,
  followers,
}

/// A screen that shows the following users and followers for the [user].
///
/// The list of users for both [type] are built in a [TabBarView] with
/// separate [_UserList]s.
class FollowingFollowerScreen extends StatelessWidget {
  const FollowingFollowerScreen({
    @required this.user,
    @required this.type,
  });

  /// The [User] for whom to show the followers and following users for.
  final User user;

  /// The [type] determines what list to show initially (Either the list of
  /// followers or the list of following users).
  final FollowingFollowerType type;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subhead;

    return DefaultTabController(
      length: 2,
      initialIndex: type == FollowingFollowerType.following ? 0 : 1,
      child: HarpyScaffold(
        title: user.name,
        appBarBottom: TabBar(
          tabs: <Widget>[
            Tab(child: Text("Following", style: textStyle)),
            Tab(child: Text("Followers", style: textStyle)),
          ],
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<UserFollowersModel>(
              builder: (_) => UserFollowersModel(userId: "${user.id}"),
            ),
            ChangeNotifierProvider<UserFollowingModel>(
              builder: (_) => UserFollowingModel(userId: "${user.id}"),
            ),
          ],
          child: const TabBarView(
            children: <Widget>[
              _UserList<UserFollowingModel>(),
              _UserList<UserFollowersModel>(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Builds the list of users for a [UserFollowingFollowersModel] using
/// [UserListTile]s.
class _UserList<T extends UserFollowingFollowersModel> extends StatelessWidget {
  const _UserList();

  void _navigate(User user) {
    HarpyNavigator.push(UserProfileScreen(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, _) {
        if (model.loading) {
          return const LoadingUserTile();
        }

        if (model.noUsersFound) {
          return const Center(child: Text("No users found"));
        }

        return SlideFadeInAnimation(
          duration: const Duration(milliseconds: 300),
          offset: const Offset(0, 100),
          child: LoadMoreList(
            onLoadMore: model.loadMore,
            enable: !model.lastPage,
            loadingText: "Loading users...",
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: model.users.length,
              itemBuilder: (_, index) => UserListTile(
                user: model.users[index],
                onUserSelected: _navigate,
              ),
            ),
          ),
        );
      },
    );
  }
}
