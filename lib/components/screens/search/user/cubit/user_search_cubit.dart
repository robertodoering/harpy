import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'user_search_cubit.freezed.dart';

/// Handles searching for twitter users.
///
/// The paginated responses from the user search request behaves strangely and
/// require us to filter possible duplicates.
class UserSearchCubit extends Cubit<PaginatedState<UsersSearchStateData>>
    with RequestLock, HarpyLogger {
  UserSearchCubit({
    this.silentErrors = false,
  }) : super(const PaginatedState.initial());

  final bool silentErrors;

  Future<void> _request({
    required String query,
    required Iterable<UserData> oldUsers,
    required int page,
  }) async {
    final newUsers = await app<TwitterApi>()
        .userService
        .usersSearch(
          q: query,
          count: 20,
          page: page,
          includeEntities: false,
        )
        .then((users) => users.map(UserData.fromUser))
        .then((users) => _filterDuplicates(oldUsers, users))
        .handleError(
          silentErrors ? silentErrorHandler : twitterApiErrorHandler,
        );

    if (newUsers != null) {
      log.fine('found ${newUsers.length} new users');

      final data = UsersSearchStateData(
        query: query,
        users: oldUsers.followedBy(newUsers).toBuiltList(),
      );

      if (newUsers.length < 5) {
        // assume last page requested
        emit(
          PaginatedState.data(
            data: data,
            cursor: null,
          ),
        );
      } else {
        emit(
          PaginatedState.data(
            data: data,
            // set cursor to the next page
            cursor: page + 1,
          ),
        );
      }
    } else {
      // request failed

      if (oldUsers.isEmpty) {
        emit(const PaginatedState.error());
      } else {
        // re-emit old data and disable loading more
        emit(
          PaginatedState.data(
            data: UsersSearchStateData(
              users: oldUsers.toBuiltList(),
              query: query,
            ),
            cursor: null,
          ),
        );
      }
    }
  }

  Future<void> search(String query) async {
    emit(const PaginatedState.loading());

    await _request(
      query: query,
      oldUsers: [],
      page: 1,
    );
  }

  Future<void> loadMore() async {
    if (lock()) {
      return;
    }

    if (state is PaginatedStateData<UsersSearchStateData> &&
        state.canLoadMore) {
      final currentState = state as PaginatedStateData<UsersSearchStateData>;

      emit(PaginatedState.loadingMore(data: currentState.data));

      await _request(
        query: currentState.data.query,
        oldUsers: currentState.data.users,
        page: currentState.cursor!,
      );
    }
  }

  void clear() {
    emit(const PaginatedState.initial());
  }
}

Iterable<UserData> _filterDuplicates(
  Iterable<UserData> oldUsers,
  Iterable<UserData> newUsers,
) {
  final filteredUsers = List.of(newUsers);

  for (final loadedUser in oldUsers) {
    for (final newUser in newUsers) {
      if (loadedUser.id == newUser.id) {
        filteredUsers.removeWhere(
          (filteredUser) => filteredUser.id == newUser.id,
        );
      }
    }
  }

  return filteredUsers;
}

@freezed
class UsersSearchStateData with _$UsersSearchStateData {
  const factory UsersSearchStateData({
    required BuiltList<UserData> users,
    required String query,
  }) = _Data;
}
