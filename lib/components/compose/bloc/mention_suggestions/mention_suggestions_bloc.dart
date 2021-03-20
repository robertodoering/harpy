import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/following_followers/following/bloc/following_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

part 'mention_suggestions_event.dart';
part 'mention_suggestions_state.dart';

class MentionSuggestionsBloc
    extends Bloc<MentionSuggestionsEvent, MentionSuggestionsState> {
  MentionSuggestionsBloc({
    @required UserData authenticatedUser,
  })  : followingBloc = FollowingBloc(userId: authenticatedUser.idStr),
        super(const MentionSuggestionsState()) {
    followingBloc.stream.listen(_followingBlocListener);
    userSearchBloc.stream.listen(_userSearchBlocListener);
  }

  final UserSearchBloc userSearchBloc = UserSearchBloc(
    silentErrors: true,
    lock: Duration.zero,
  );

  final FollowingBloc followingBloc;

  /// Whether user suggestions are currently being loaded.
  bool get loadingSearchedUsers => userSearchBloc.state is LoadingPaginatedData;

  void _followingBlocListener(PaginatedState state) {
    if (followingBloc.hasData) {
      add(UpdateMentionsSuggestionsEvent(
        followingUsers: followingBloc.users,
      ));
    }
  }

  void _userSearchBlocListener(PaginatedState state) {
    if (state is LoadedData) {
      add(UpdateMentionsSuggestionsEvent(
        searchedUsers: userSearchBloc.users,
        searchQuery: userSearchBloc.lastQuery,
      ));
    }
  }

  @override
  Stream<MentionSuggestionsState> mapEventToState(
    MentionSuggestionsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
