part of 'mention_suggestions_bloc.dart';

abstract class MentionSuggestionsEvent extends Equatable {
  const MentionSuggestionsEvent();

  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  });
}

class FindMentionsEvent extends MentionSuggestionsEvent {
  const FindMentionsEvent(this.text);

  final String text;

  @override
  List<Object> get props => <Object>[
        text,
      ];

  @override
  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  }) async* {
    final String query =
        text.contains('@') ? text.substring(text.indexOf('@') + 1) : text;

    if (query.isNotEmpty && currentState.searchedUsers[query] == null) {
      Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
        // only start searching if no new query has been fired for 300ms
        // to prevent spamming requests when quickly typing
        if (bloc.state.lastQuery == query) {
          bloc.userSearchBloc
            ..add(const ClearSearchedUsers())
            ..add(SearchUsers(query));
        }
      });
    }

    yield MentionSuggestionsState(
      lastQuery: query,
      searchedUsers: currentState.searchedUsers,
      followingUsers: currentState.followingUsers,
    );
  }
}

class UpdateMentionsSuggestionsEvent extends MentionSuggestionsEvent {
  const UpdateMentionsSuggestionsEvent({
    this.followingUsers,
    this.searchedUsers,
    this.searchQuery,
  });

  final List<UserData> followingUsers;
  final List<UserData> searchedUsers;
  final String searchQuery;

  @override
  List<Object> get props => <Object>[
        followingUsers,
        searchedUsers,
        searchQuery,
      ];

  Map<String, List<UserData>> _searchedUsers(
    MentionSuggestionsState currentState,
  ) {
    if (searchedUsers != null && searchQuery != null) {
      final Map<String, List<UserData>> searchedUsersMap =
          Map<String, List<UserData>>.from(currentState.searchedUsers);

      searchedUsersMap[searchQuery] = searchedUsers;

      return searchedUsersMap;
    } else {
      return currentState.searchedUsers;
    }
  }

  @override
  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  }) async* {
    yield MentionSuggestionsState(
      lastQuery: currentState.lastQuery,
      searchedUsers: _searchedUsers(currentState),
      followingUsers: followingUsers ?? currentState.followingUsers,
    );
  }
}
