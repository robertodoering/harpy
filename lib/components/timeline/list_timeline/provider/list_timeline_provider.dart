import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final listTimelineProvider = StateNotifierProvider.autoDispose
    .family<ListTimelineNotifier, TimelineState, String>(
  (ref, listId) => ListTimelineNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiProvider),
    listId: listId,
  ),
  name: 'ListTimelineProvider',
);

class ListTimelineNotifier extends TimelineNotifier {
  ListTimelineNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required String listId,
  })  : _read = ref.read,
        _listId = listId,
        super(ref: ref, twitterApi: twitterApi) {
    loadInitial();
  }

  final Reader _read;
  final String _listId;

  @override
  TimelineFilter? currentFilter() {
    final state = _read(timelineFilterProvider);
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
