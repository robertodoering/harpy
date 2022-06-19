import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

final homeTimelineFilterProvider = StateNotifierProvider<
    HomeTimelineFilterNotifier, TimelineFilterSelectionState>(
  (ref) => HomeTimelineFilterNotifier(read: ref.read),
  name: 'HomeTimelineFilterprovider',
);

class HomeTimelineFilterNotifier extends TimelineFilterSelectionNotifier {
  HomeTimelineFilterNotifier({
    required super.read,
  }) : _read = read;

  final Reader _read;

  @override
  ActiveTimelineFilter? get activeFilter =>
      _read(timelineFilterProvider).activeHomeFilter();

  @override
  bool get showUnique => false;

  @override
  String? get uniqueName => null;

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting home timeline filter');

    _read(timelineFilterProvider.notifier).selectHomeTimelineFilter(uuid);
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing home timeline filter selection');

    _read(timelineFilterProvider.notifier).removeHomeTimelineFilter();
  }
}
