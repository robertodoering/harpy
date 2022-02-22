import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final likesTimelineProvider = StateNotifierProvider.autoDispose
    .family<LikesTimelineNotifier, TimelineState, String>(
  (ref, handle) => LikesTimelineNotifier(ref: ref, handle: handle),
  name: 'LikesTimelineProvider',
);

class LikesTimelineNotifier extends TimelineNotifier {
  LikesTimelineNotifier({
    required Ref ref,
    required String handle,
  })  : _read = ref.read,
        _handle = handle,
        super(ref: ref) {
    loadInitial();
  }

  final Reader _read;
  final String _handle;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _read(twitterApiProvider).tweetService.listFavorites(
          screenName: _handle,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
        );
  }
}
