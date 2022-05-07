import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final likesTimelineProvider = StateNotifierProvider.autoDispose
    .family<LikesTimelineNotifier, TimelineState, String>(
  (ref, userId) => LikesTimelineNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiProvider),
    userId: userId,
  ),
  cacheTime: const Duration(minutes: 5),
  name: 'LikesTimelineProvider',
);

class LikesTimelineNotifier extends TimelineNotifier {
  LikesTimelineNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required String userId,
  })  : _userId = userId,
        super(ref: ref, twitterApi: twitterApi) {
    loadInitial();
  }

  final String _userId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.tweetService.listFavorites(
      userId: _userId,
      count: 200,
      sinceId: sinceId,
      maxId: maxId,
    );
  }
}
