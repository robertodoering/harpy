import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final listTimelineFilterProvider =
    Provider.autoDispose.family<TimelineFilter?, String>(
  (ref, listId) {
    final state = ref.watch(timelineFilterProvider);
    return state.filterByUuid(state.activeListFilter(listId)?.uuid);
  },
  name: 'ListTimelineFilterProvider',
);

final listTimelineProvider = StateNotifierProvider.autoDispose
    .family<ListTimelineNotifier, TimelineState, String>(
  (ref, listId) => ListTimelineNotifier(ref: ref, listId: listId),
  name: 'ListTimelineProvider',
);

class ListTimelineNotifier extends TimelineNotifier {
  ListTimelineNotifier({
    required Ref ref,
    required String listId,
  })  : _read = ref.read,
        _listId = listId,
        super(ref: ref) {
    loadInitial();
  }

  final Reader _read;
  final String _listId;

  @override
  TimelineFilter? currentFilter() {
    return _read(listTimelineFilterProvider(_listId));
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _read(twitterApiProvider).listsService.statuses(
          listId: _listId,
          count: 200,
          maxId: maxId,
        );
  }
}
