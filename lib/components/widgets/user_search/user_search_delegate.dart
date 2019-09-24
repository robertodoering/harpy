import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/load_more_list.dart';
import 'package:harpy/components/widgets/shared/loading_tile.dart';
import 'package:harpy/components/widgets/user_search/user_list_tile.dart';
import 'package:harpy/components/widgets/user_search/user_search_action.dart';
import 'package:harpy/models/user_search_history_model.dart';
import 'package:harpy/models/user_search_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The [SearchDelegate] for the user search.
///
/// Used by the [UserSearchAction] in the [HomeScreen] to open a search with
/// [showSearch].
///
/// The suggestions are previously entered queries that are saved in the
/// [SharedPreferences] with the [UserSearchHistoryModel].
///
/// The results are built from paginated responses with the [UserSearchModel]
/// and more can be requested by scrolling to the bottom of the list using a
/// [LoadMoreList].
class UserSearchDelegate extends SearchDelegate<User> {
  Widget _buildResultList() {
    return Consumer<UserSearchModel>(
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
              itemBuilder: (context, index) => UserListTile(
                user: model.users[index],
                onUserSelected: (user) => close(context, user),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: Navigator.of(context).pop,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ChangeNotifierProvider<UserSearchModel>(
      builder: (_) => UserSearchModel(
        userSearchHistoryModel: Provider.of<UserSearchHistoryModel>(context),
        query: query,
      ),
      child: _buildResultList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final userSearchHistoryModel = Provider.of<UserSearchHistoryModel>(context);

    return ListView(
      children: userSearchHistoryModel
          .searchHistory()
          .map((previousQuery) => ListTile(
                leading: Icon(Icons.history),
                title: Text(previousQuery),
                onTap: () {
                  query = previousQuery;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }
}
