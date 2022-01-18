import 'package:harpy/components/components.dart';

class HomeTimelineFilterCubit extends TimelineFilterSelectionCubit {
  HomeTimelineFilterCubit({
    required TimelineFilterCubit timelineFilterCubit,
  }) : super(timelineFilterCubit: timelineFilterCubit);

  @override
  ActiveTimelineFilter? get activeFilter =>
      timelineFilterCubit.state.activeHomeFilter();

  @override
  bool get showUnique => false;

  @override
  String? get uniqueName => null;

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting home timeline filter');

    timelineFilterCubit.selectHomeTimelineFilter(uuid);
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing home timeline filter selection');

    timelineFilterCubit.removeHomeTimelineFilter();
  }
}
