import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:pedantic/pedantic.dart';

part 'mention_suggestions_event.dart';
part 'mention_suggestions_state.dart';

// TODO: refactor this abomination

class MentionSuggestionsBloc
    extends Bloc<MentionSuggestionsEvent, MentionSuggestionsState> {
  MentionSuggestionsBloc({
    required UserData authenticatedUser,
  })  : followingCubit = FollowingCubit(userId: authenticatedUser.id),
        super(const MentionSuggestionsState()) {
    on<MentionSuggestionsEvent>((event, emit) => event.handle(this, emit));
    followingCubit.stream.listen(_followingCubitListener);
    userSearchBloc.stream.listen(_userSearchBlocListener);
  }

  final UserSearchBloc userSearchBloc = UserSearchBloc(
    silentErrors: true,
    lock: Duration.zero,
  );

  final FollowingCubit followingCubit;

  /// Whether user suggestions are currently being loaded.
  bool get loadingSearchedUsers => userSearchBloc.state is LoadingPaginatedData;

  void _followingCubitListener(PaginatedState<BuiltList<UserData>> state) {
    if (followingCubit.state is PaginatedStateData) {
      add(
        UpdateMentionsSuggestionsEvent(
          followingUsers: state.data?.toList() ?? [],
        ),
      );
    }
  }

  void _userSearchBlocListener(LegacyPaginatedState state) {
    if (state is LoadedData) {
      add(
        UpdateMentionsSuggestionsEvent(
          searchedUsers: userSearchBloc.users,
          searchQuery: userSearchBloc.lastQuery,
        ),
      );
    }
  }
}
