import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final userTimelineProvider = StateNotifierProvider.autoDispose
    .family<UserTimelineNotifier, TimelineState, String>(
  (ref, userId) => UserTimelineNotifier(ref: ref, userId: userId),
  name: 'UserTimelineProvider',
);

class UserTimelineNotifier extends TimelineNotifier {
  UserTimelineNotifier({
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
  TimelineFilter? currentFilter() {
    final state = _read(timelineFilterProvider);
    return state.filterByUuid(state.activeUserFilter(_userId)?.uuid);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _read(twitterApiProvider).timelineService.userTimeline(
          userId: _userId,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter?.excludes.replies,
        );
  }
}
