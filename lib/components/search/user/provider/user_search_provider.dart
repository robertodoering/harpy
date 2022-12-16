import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'user_search_provider.freezed.dart';

final userSearchProvider = StateNotifierProvider.autoDispose<UserSearchNotifier,
    PaginatedState<UsersSearchData>>(
  (ref) => UserSearchNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
  ),
  name: 'UserSearchProvider',
);

class UserSearchNotifier extends StateNotifier<PaginatedState<UsersSearchData>>
    with RequestLock, LoggerMixin {
  UserSearchNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        super(const PaginatedState.initial());

  final Ref _ref;
  final TwitterApi _twitterApi;

  Future<void> _load({
    required String query,
    required int cursor,
    required Iterable<UserData> oldUsers,
  }) async {
    final newUsers = await _twitterApi.userService
        .usersSearch(q: query, count: 20, page: cursor, includeEntities: false)
        .then((users) => users.map(UserData.fromV1))
        .then(
          (users) => users.whereNot(
            (newUser) => oldUsers.any((oldUser) => newUser.id == oldUser.id),
          ),
        )
        .handleError((e, st) => twitterErrorHandler(_ref, e, st));

    if (newUsers != null) {
      log.fine('found ${newUsers.length} new users');

      final data = UsersSearchData(
        query: query,
        users: oldUsers.followedBy(newUsers).toBuiltList(),
      );

      state = PaginatedState.data(
        data: data,
        cursor: newUsers.length > 5 ? cursor + 1 : null,
      );
    } else {
      if (oldUsers.isEmpty) {
        state = const PaginatedState.error();
      } else {
        // re-emit old data and disable loading more
        state = PaginatedState.data(
          data: UsersSearchData(
            users: oldUsers.toBuiltList(),
            query: query,
          ),
        );
      }
    }
  }

  Future<void> search(String query) async {
    state = const PaginatedState.loading();

    await _load(query: query, oldUsers: [], cursor: 1);
  }

  Future<void> loadMore() async {
    if (lock()) return;

    if (state.canLoadMore) {
      await state.mapOrNull(
        data: (value) async {
          state = PaginatedState.loadingMore(data: value.data);

          await _load(
            query: value.data.query,
            oldUsers: value.data.users,
            cursor: value.cursor!,
          );
        },
      );
    }
  }

  void clear() {
    state = const PaginatedState.initial();
  }
}

@freezed
class UsersSearchData with _$UsersSearchData {
  const factory UsersSearchData({
    required BuiltList<UserData> users,
    required String query,
  }) = _Data;
}
