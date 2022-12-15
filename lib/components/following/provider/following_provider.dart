import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final followingProvider = StateNotifierProvider.autoDispose
    .family<FollowingNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, handle) => FollowingNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
    handle: handle,
  ),
  name: 'FollowingProvider',
);

class FollowingNotifier extends PaginatedUsersNotifier {
  FollowingNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required String handle,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        _handle = handle,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Ref _ref;
  final TwitterApi _twitterApi;
  final String _handle;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_ref, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return _twitterApi.userService.friendsList(
      screenName: _handle,
      cursor: cursor,
      skipStatus: true,
      count: 200,
    );
  }
}
