import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final userTimelineFilterProvider =
    Provider.autoDispose.family<TimelineFilter?, String>(
  (ref, userId) {
    final state = ref.watch(timelineFilterProvider);
    return state.filterByUuid(state.activeUserFilter(userId)?.uuid);
  },
  name: 'UserTimelineFilterProvider',
);

final userTimelineProvider = StateNotifierProvider.autoDispose
    .family<UserTimelineNotifier, TimelineState, String>(
  UserTimelineNotifier.new,
  name: 'UserTimelineProvider',
);

class UserTimelineNotifier extends TimelineNotifier {
  UserTimelineNotifier(this._ref, this._userId) : super(ref: _ref) {
    loadInitial();
  }

  final Ref _ref;
  final String _userId;

  @override
  TimelineFilter? currentFilter() {
    return _ref.read(userTimelineFilterProvider(_userId));
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _ref.read(twitterApiProvider).timelineService.userTimeline(
          userId: _userId,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter?.excludes.replies,
        );
  }
}
