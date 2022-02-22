import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final followersProvider = StateNotifierProvider.autoDispose
    .family<FollowersNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, userId) => FollowersNotifier(
    twitterApi: ref.watch(twitterApiProvider),
    userId: userId,
  ),
  name: 'FollowersProvider',
);

class FollowersNotifier extends PaginatedUsersNotifier {
  FollowersNotifier({
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
    return _twitterApi.userService.followersList(
      userId: _userId,
      cursor: cursor,
      skipStatus: true,
      count: 200,
    );
  }
}
