import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ListTimelineCubit extends TimelineCubit {
  ListTimelineCubit({
    required this.listId,
  }) {
    loadInitial();
  }

  final String listId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().listsService.statuses(
          listId: listId,
          count: 200,
          maxId: maxId,
        );
  }
}
