import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final userTimelineProvider = StateNotifierProvider.autoDispose
    .family<UserTimelineNotifier, TimelineState, String>(
  (ref, userId) {
    ref.cacheFor(const Duration(minutes: 5));

    return UserTimelineNotifier(
      ref: ref,
      twitterApi: ref.watch(twitterApiV1Provider),
      userId: userId,
    );
  },
  name: 'UserTimelineProvider',
);

class UserTimelineNotifier extends TimelineNotifier {
  UserTimelineNotifier({
    required super.ref,
    required super.twitterApi,
    required String userId,
  }) : _userId = userId {
    // TODO: remove when refactoring timelines
    if (!isTest) loadInitial();
  }

  final String _userId;

  @override
  TimelineFilter? currentFilter() {
    final state = ref.read(timelineFilterProvider);
    return state.filterByUuid(state.activeUserFilter(_userId)?.uuid);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.timelineService.userTimeline(
      userId: _userId,
      count: 200,
      sinceId: sinceId,
      maxId: maxId,
      excludeReplies: filter?.excludes.replies,
    );
  }
}
