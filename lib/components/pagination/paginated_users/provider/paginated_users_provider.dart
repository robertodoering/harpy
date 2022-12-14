import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Implementation for a [PaginatedNotifierMixin] to handle [PaginatedUsers]
/// responses.
///
/// For example implementations, see:
/// * [FollowersNotifier]
/// * [FollowingNotifier]
/// * [ListsMembersNotifier]
abstract class PaginatedUsersNotifier
    extends StateNotifier<PaginatedState<BuiltList<UserData>>>
    with
        RequestLock,
        LoggerMixin,
        PaginatedNotifierMixin<PaginatedUsers, BuiltList<UserData>> {
  PaginatedUsersNotifier(super.initialState);

  @override
  Future<void> onInitialResponse(PaginatedUsers response) async {
    log.fine('received initial paginated users response');

    final users = response.users?.map(UserData.fromV1).toBuiltList();

    if (users == null || users.isEmpty) {
      state = const PaginatedState.noData();
    } else {
      final cursor = int.tryParse(response.nextCursorStr ?? '');

      state = PaginatedState.data(
        data: users,
        cursor: cursor,
      );
    }
  }

  @override
  Future<void> onMoreResponse(
    PaginatedUsers response,
    BuiltList<UserData> data,
  ) async {
    log.fine('received loading more paginated users response');

    final users =
        response.users?.map(UserData.fromV1) ?? const Iterable.empty();

    final cursor = int.tryParse(response.nextCursorStr ?? '');

    state = PaginatedState.data(
      data: data.rebuild((builder) => builder.addAll(users)),
      cursor: cursor,
    );
  }
}
