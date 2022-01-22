import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserTimelineCubit extends TimelineCubit {
  UserTimelineCubit({
    required TimelineFilterCubit timelineFilterCubit,
    required this.id,
  }) : super(timelineFilterCubit: timelineFilterCubit) {
    loadInitial();
  }

  final String id;

  @override
  TimelineFilter? filterFromState(TimelineFilterState state) {
    return state.userFilter(id);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().timelineService.userTimeline(
          userId: id,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter?.excludes.replies,
        );
  }
}
