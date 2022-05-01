import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final followingProvider = StateNotifierProvider.autoDispose
    .family<FollowingNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, userId) => FollowingNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    userId: userId,
  ),
  name: 'FollowingProvider',
);

class FollowingNotifier extends PaginatedUsersNotifier {
  FollowingNotifier({
    required Reader read,
    required TwitterApi twitterApi,
    required String userId,
  })  : _read = read,
        _twitterApi = twitterApi,
        _userId = userId,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Reader _read;
  final TwitterApi _twitterApi;
  final String _userId;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_read, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return _twitterApi.userService.friendsList(
      userId: _userId,
      cursor: cursor,
      skipStatus: true,
      count: 200,
    );
  }
}
