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
    userSearchCubit.stream.listen(_userSearchCubitListener);
  }

  final userSearchCubit = UserSearchCubit(
    silentErrors: true,
  );

  final FollowingCubit followingCubit;

  /// Whether user suggestions are currently being loaded.
  bool get loadingSearchedUsers =>
      userSearchCubit.state is PaginatedStateLoadingMore;

  void _followingCubitListener(PaginatedState<BuiltList<UserData>> state) {
    if (followingCubit.state is PaginatedStateData) {
      add(
        UpdateMentionsSuggestionsEvent(
          followingUsers: state.data?.toList() ?? [],
        ),
      );
    }
  }

  void _userSearchCubitListener(PaginatedState<UsersSearchStateData> state) {
    if (state is PaginatedStateData) {
      add(
        UpdateMentionsSuggestionsEvent(
          searchedUsers: state.data!.users.toList(),
          searchQuery: state.data!.query,
        ),
      );
    }
  }
}
