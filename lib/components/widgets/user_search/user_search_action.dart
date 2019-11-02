import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/user_search/user_search_delegate.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';

/// An [IconButton] to call [showSearch] with a [UserSearchDelegate] to search
/// for users.
///
/// Used in the [HomeScreen] as an action in the [HarpyScaffold].
class UserSearchAction extends StatelessWidget {
  Future<void> _searchUser(BuildContext context) async {
    final User user = await showSearch<User>(
      context: context,
      delegate: UserSearchDelegate(),
    );

    if (user != null) {
      HarpyNavigator.pushUserProfileScreen(user: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () => _searchUser(context),
    );
  }
}
