import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final listTimelineProvider = StateNotifierProvider.autoDispose
    .family<ListTimelineNotifier, TimelineState, String>(
  (ref, listId) {
    ref.cacheFor(const Duration(minutes: 5));

    return ListTimelineNotifier(
      ref: ref,
      twitterApi: ref.watch(twitterApiV1Provider),
      listId: listId,
    );
  },
  name: 'ListTimelineProvider',
);

class ListTimelineNotifier extends TimelineNotifier {
  ListTimelineNotifier({
    required super.ref,
    required super.twitterApi,
    required String listId,
  }) : _listId = listId {
    loadInitial();
  }

  final String _listId;

  @override
  TimelineFilter? currentFilter() {
    final state = ref.read(timelineFilterProvider);
    return state.filterByUuid(state.activeListFilter(_listId)?.uuid);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.listsService.statuses(
      listId: _listId,
      count: 200,
      maxId: maxId,
    );
  }
}
