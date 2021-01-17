import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_event.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_state.dart';
import 'package:harpy/components/following_followers/following/bloc/following_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

class MentionSuggestionsBloc
    extends Bloc<MentionSuggestionsEvent, MentionSuggestionsState> {
  MentionSuggestionsBloc({
    @required UserData authenticatedUser,
  })  : followingBloc = FollowingBloc(userId: authenticatedUser.idStr),
        super(InitialMentionSuggestionsState()) {
    followingBloc.listen((PaginatedState state) {
      add(const UpdatedSuggestions());
    });

    userSearchBloc.listen((PaginatedState state) {
      if (state is LoadedData) {
        searchedUsers[userSearchBloc.lastQuery] = userSearchBloc.users;
      }
      add(const UpdatedSuggestions());
    });
  }

  final UserSearchBloc userSearchBloc = UserSearchBloc(
    silentErrors: true,
    lock: Duration.zero,
  );
  final FollowingBloc followingBloc;

  static MentionSuggestionsBloc of(BuildContext context) =>
      context.watch<MentionSuggestionsBloc>();

  /// The last used query.
  String query = '';

  /// The list of following users filtered by the query.
  List<UserData> get followingUsers => followingBloc.hasData
      ? followingBloc.users
          .where((UserData user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.screenName.toLowerCase().startsWith(query.toLowerCase()))
          .toList()
      : <UserData>[];

  /// Searched users mapped by the query.
  final Map<String, List<UserData>> searchedUsers = <String, List<UserData>>{};

  /// The suggested users for the current query based on the [searchedUsers].
  List<UserData> get suggestedUsers => searchedUsers[query] ?? <UserData>[];

  /// Whether user suggestions for the current [query] exist.
  bool get hasUserSuggestions =>
      followingUsers.isNotEmpty || suggestedUsers.isNotEmpty;

  /// Whether user suggestions are currently being loaded.
  bool get loadingSearchedUsers => userSearchBloc.state is LoadingPaginatedData;

  @override
  Stream<MentionSuggestionsState> mapEventToState(
    MentionSuggestionsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
