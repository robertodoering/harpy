import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

final homeTimelineFilterProvider = StateNotifierProvider.autoDispose<
    HomeTimelineFilterNotifier, TimelineFilterSelectionState>(
  (ref) => HomeTimelineFilterNotifier(ref: ref),
  name: 'HomeTimelineFilterprovider',
);

class HomeTimelineFilterNotifier extends TimelineFilterSelectionNotifier {
  HomeTimelineFilterNotifier({
    required super.ref,
  });

  @override
  ActiveTimelineFilter? get activeFilter =>
      ref.read(timelineFilterProvider).activeHomeFilter();

  @override
  bool get showUnique => false;

  @override
  String? get uniqueName => null;

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting home timeline filter');

    ref.read(timelineFilterProvider.notifier).selectHomeTimelineFilter(uuid);
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing home timeline filter selection');

    ref.read(timelineFilterProvider.notifier).removeHomeTimelineFilter();
  }
}
