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
  ListTimelineNotifier.new,
  name: 'ListTimelineProvider',
);

class ListTimelineNotifier extends TimelineNotifier {
  ListTimelineNotifier(this._ref, this._listId) : super(ref: _ref) {
    loadInitial();
  }

  final Ref _ref;
  final String _listId;

  @override
  TimelineFilter? currentFilter() {
    return _ref.read(listTimelineFilterProvider(_listId));
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _ref.read(twitterApiProvider).listsService.statuses(
          listId: _listId,
          count: 200,
          maxId: maxId,
        );
  }
}
