part of 'mention_suggestions_bloc.dart';

abstract class MentionSuggestionsEvent {
  const MentionSuggestionsEvent();

  Future<void> handle(MentionSuggestionsBloc bloc, Emitter emit);
}

class FindMentionsEvent extends MentionSuggestionsEvent {
  const FindMentionsEvent(this.text);

  final String text;

  @override
  Future<void> handle(MentionSuggestionsBloc bloc, Emitter emit) async {
    final query =
        text.contains('@') ? text.substring(text.indexOf('@') + 1) : text;

    if (query.isNotEmpty && bloc.state.searchedUsers[query] == null) {
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
          // only start searching if no new query has been fired for 300ms
          // to prevent spamming requests when quickly typing
          if (bloc.state.lastQuery == query) {
            bloc.userSearchBloc
              ..add(const ClearSearchedUsers())
              ..add(SearchUsers(query));
          }
        }),
      );
    }

    emit(
      MentionSuggestionsState(
        lastQuery: query,
        searchedUsers: bloc.state.searchedUsers,
        followingUsers: bloc.state.followingUsers,
      ),
    );
  }
}

class UpdateMentionsSuggestionsEvent extends MentionSuggestionsEvent {
  const UpdateMentionsSuggestionsEvent({
    this.followingUsers,
    this.searchedUsers,
    this.searchQuery,
  });

  final List<UserData>? followingUsers;
  final List<UserData>? searchedUsers;
  final String? searchQuery;

  Map<String, List<UserData>?> _searchedUsers(
    MentionSuggestionsState currentState,
  ) {
    if (searchedUsers != null && searchQuery != null) {
      final searchedUsersMap = Map<String, List<UserData>?>.from(
        currentState.searchedUsers,
      );

      searchedUsersMap[searchQuery!] = searchedUsers;

      return searchedUsersMap;
    } else {
      return currentState.searchedUsers;
    }
  }

  @override
  Future<void> handle(MentionSuggestionsBloc bloc, Emitter emit) async {
    MentionSuggestionsState(
      lastQuery: bloc.state.lastQuery,
      searchedUsers: _searchedUsers(bloc.state),
      followingUsers: followingUsers ?? bloc.state.followingUsers,
    );
  }
}
