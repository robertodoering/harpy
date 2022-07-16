import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final followersProvider = StateNotifierProvider.autoDispose
    .family<FollowersNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, handle) => FollowersNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    handle: handle,
  ),
  name: 'FollowersProvider',
);

class FollowersNotifier extends PaginatedUsersNotifier {
  FollowersNotifier({
    required Reader read,
    required TwitterApi twitterApi,
    required String handle,
  })  : _read = read,
        _twitterApi = twitterApi,
        _handle = handle,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Reader _read;
  final TwitterApi _twitterApi;
  final String _handle;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_read, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return _twitterApi.userService.followersList(
      screenName: _handle,
      cursor: cursor,
      skipStatus: true,
      count: 200,
    );
  }
}
