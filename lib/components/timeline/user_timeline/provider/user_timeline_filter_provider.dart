import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final userTimelineFilterProvider = StateNotifierProvider.autoDispose
    .family<UserTimelineFilterNotifier, TimelineFilterSelectionState, UserData>(
  (ref, user) => UserTimelineFilterNotifier(
    ref: ref,
    user: user,
  ),
  name: 'UserTimelineFilterprovider',
);

class UserTimelineFilterNotifier extends TimelineFilterSelectionNotifier {
  UserTimelineFilterNotifier({
    required super.ref,
    required UserData user,
  }) : _user = user;

  final UserData _user;

  @override
  ActiveTimelineFilter? get activeFilter =>
      ref.read(timelineFilterProvider).activeUserFilter(_user.id);

  @override
  bool get showUnique => true;

  @override
  String get uniqueName => '@${_user.handle}';

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting user timeline filter');

    ref.read(timelineFilterProvider.notifier).selectUserTimelineFilter(
          uuid,
          user: state.isUnique ? _user : null,
        );
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing user timeline filter selection');

    ref.read(timelineFilterProvider.notifier).removeUserTimelineFilter(
          user: state.isUnique ? _user : null,
        );
  }
}
