import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:tuple/tuple.dart';

final listTimelineFilterProvider = StateNotifierProvider.autoDispose.family<
    ListTimelineFilterNotifier,
    TimelineFilterSelectionState,
    Tuple2<String, String>>(
  (ref, args) => ListTimelineFilterNotifier(
    ref: ref,
    listId: args.item1,
    listName: args.item2,
  ),
  name: 'ListTimelineFilterprovider',
);

class ListTimelineFilterNotifier extends TimelineFilterSelectionNotifier {
  ListTimelineFilterNotifier({
    required super.ref,
    required String listId,
    required String listName,
  })  : _listId = listId,
        _listName = listName;

  final String _listId;
  final String _listName;

  @override
  ActiveTimelineFilter? get activeFilter =>
      ref.read(timelineFilterProvider).activeListFilter(_listId);

  @override
  bool get showUnique => true;

  @override
  String get uniqueName => _listName;

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting list timeline filter');

    ref.read(timelineFilterProvider.notifier).selectListTimelineFilter(
          uuid,
          listId: state.isUnique ? _listId : null,
          listName: state.isUnique ? _listName : null,
        );
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing list timeline filter selection');

    ref.read(timelineFilterProvider.notifier).removeListTimelineFilter(
          listId: state.isUnique ? _listId : null,
        );
  }
}
