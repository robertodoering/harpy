import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final likesTimelineProvider = StateNotifierProvider.autoDispose
    .family<LikesTimelineNotifier, TimelineState, String>(
  (ref, userId) => LikesTimelineNotifier(ref: ref, userId: userId),
  name: 'LikesTimelineProvider',
);

class LikesTimelineNotifier extends TimelineNotifier {
  LikesTimelineNotifier({
    required Ref ref,
    required String userId,
  })  : _read = ref.read,
        _userId = userId,
        super(ref: ref) {
    loadInitial();
  }

  final Reader _read;
  final String _userId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _read(twitterApiProvider).tweetService.listFavorites(
          userId: _userId,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
        );
  }
}
