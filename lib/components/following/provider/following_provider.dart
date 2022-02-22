import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final followingProvider = StateNotifierProvider.autoDispose
    .family<FollowingNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, userId) => FollowingNotifier(
    twitterApi: ref.watch(twitterApiProvider),
    userId: userId,
  ),
  name: 'FollowingProvider',
);

class FollowingNotifier extends PaginatedUsersNotifier {
  FollowingNotifier({
    required TwitterApi twitterApi,
    required String userId,
  })  : _twitterApi = twitterApi,
        _userId = userId,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final TwitterApi _twitterApi;
  final String _userId;

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
