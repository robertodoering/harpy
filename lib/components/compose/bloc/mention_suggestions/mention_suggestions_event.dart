import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_bloc.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_state.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';

@immutable
abstract class MentionSuggestionsEvent {
  const MentionSuggestionsEvent();

  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  });
}

class UpdatedSuggestions extends MentionSuggestionsEvent {
  const UpdatedSuggestions();

  @override
  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  }) async* {
    yield UpdatedSuggestionsState();
  }
}

class FindMentionsEvent extends MentionSuggestionsEvent {
  const FindMentionsEvent(this.text);

  final String text;

  @override
  Stream<MentionSuggestionsState> applyAsync({
    MentionSuggestionsState currentState,
    MentionSuggestionsBloc bloc,
  }) async* {
    final String query =
        text.contains('@') ? text.substring(text.indexOf('@') + 1) : text;

    bloc.query = query;

    if (bloc.query.isNotEmpty && bloc.searchedUsers[bloc.query] == null) {
      Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
        // only start searching if no new query has been fired for 300ms
        // to prevent spamming requests when quickly typing
        if (bloc.query == query) {
          bloc.userSearchBloc
            ..add(const ClearSearchedUsers())
            ..add(SearchUsers(bloc.query));
        }
      });
    }

    yield UpdatedSuggestionsState();
  }
}
