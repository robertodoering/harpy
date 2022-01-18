import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ListTimelineCubit extends TimelineCubit {
  ListTimelineCubit({
    required TimelineFilterCubit timelineFilterCubit,
    required this.listId,
  }) : super(timelineFilterCubit: timelineFilterCubit) {
    loadInitial();
  }

  final String listId;

  @override
  TimelineFilter? filterFromState(TimelineFilterState state) {
    return state.listFilter(listId);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().listsService.statuses(
          listId: listId,
          count: 200,
          maxId: maxId,
        );
  }
}
