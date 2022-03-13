import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';

final userProvider = StateNotifierProvider.autoDispose
    .family<UserNotifier, AsyncValue<UserData>, String>(
  (ref, handle) => UserNotifier(
    handle: handle,
    twitterApi: ref.watch(twitterApiProvider),
  ),
  name: 'UserProvider',
);

class UserNotifier extends StateNotifier<AsyncValue<UserData>> {
  UserNotifier({
    required String handle,
    required TwitterApi twitterApi,
  })  : _handle = handle,
        _twitterApi = twitterApi,
        super(const AsyncValue.loading());

  final String _handle;
  final TwitterApi _twitterApi;

  Future<void> load([UserData? user]) async {
    if (user != null) {
      state = AsyncData(user);
    } else {
      state = await AsyncValue.guard(
        () => _twitterApi.userService
            .usersShow(screenName: _handle)
            .then(UserData.fromUser),
      );
    }
  }
}
