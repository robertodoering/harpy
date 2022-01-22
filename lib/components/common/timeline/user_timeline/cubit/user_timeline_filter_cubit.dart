import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserTimelineFilterCubit extends TimelineFilterSelectionCubit {
  UserTimelineFilterCubit({
    required TimelineFilterCubit timelineFilterCubit,
    required this.user,
  }) : super(timelineFilterCubit: timelineFilterCubit);

  final UserData user;

  @override
  ActiveTimelineFilter? get activeFilter =>
      timelineFilterCubit.state.activeUserFilter(user.id);

  @override
  bool get showUnique => true;

  @override
  String? get uniqueName => '@${user.handle}';

  @override
  void selectTimelineFilter(String uuid) {
    log.fine('selecting user timeline filter');

    timelineFilterCubit.selectUserTimelineFilter(
      uuid,
      user: state.isUnique ? user : null,
    );
  }

  @override
  void removeTimelineFilterSelection() {
    log.fine('removing user timeline filter selection');

    timelineFilterCubit.removeUserTimelineFilter(
      user: state.isUnique ? user : null,
    );
  }
}
