part of 'mention_suggestions_bloc.dart';

class MentionSuggestionsState extends Equatable {
  const MentionSuggestionsState({
    this.lastQuery = '',
    this.searchedUsers = const <String, List<UserData>>{},
    this.followingUsers = const <UserData>[],
  });

  final String lastQuery;

  /// Searched users mapped by their query.
  final Map<String, List<UserData>?> searchedUsers;

  final List<UserData> followingUsers;

  /// The list of following users filtered by the query.
  List<UserData> get filteredFollowing => followingUsers.isNotEmpty
      ? followingUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(lastQuery.toLowerCase()) ||
                user.handle.toLowerCase().startsWith(lastQuery.toLowerCase()),
          )
          .toList()
      : <UserData>[];

  /// The searched users for the current query.
  List<UserData> get filteredSearchedUsers =>
      searchedUsers[lastQuery] ?? <UserData>[];

  /// Whether user suggestions for the current query exist.
  bool get hasSuggestions =>
      filteredFollowing.isNotEmpty || filteredSearchedUsers.isNotEmpty;

  @override
  List<Object> get props => <Object>[
        lastQuery,
        searchedUsers,
        followingUsers,
      ];
}
