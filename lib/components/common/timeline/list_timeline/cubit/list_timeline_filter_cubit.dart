import 'package:harpy/components/components.dart';

class ListTimelineFilterCubit extends TimelineFilterSelectionCubit {
  ListTimelineFilterCubit({
    required TimelineFilterCubit timelineFilterCubit,
    required this.listId,
    required this.listName,
  }) : super(timelineFilterCubit: timelineFilterCubit);

  final String listId;
  final String listName;

  @override
  ActiveTimelineFilter? get activeFilter =>
      timelineFilterCubit.state.activeListFilter(listId);

  @override
  bool get showUnique => true;

  @override
  String? get uniqueName => listName;

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting list timeline filter');

    timelineFilterCubit.selectListTimelineFilter(
      uuid,
      listId: state.isUnique ? listId : null,
      listName: state.isUnique ? listName : null,
    );
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing list timeline filter selection');

    timelineFilterCubit.removeListTimelineFilter(
      listId: state.isUnique ? listId : null,
    );
  }
}
