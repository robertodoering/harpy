import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class LikesTimelineCubit extends TimelineCubit {
  LikesTimelineCubit({
    required this.handle,
  }) {
    loadInitial();
  }

  final String? handle;

  @override
  void persistFilter(String encodedFilter) {}

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().tweetService.listFavorites(
          screenName: handle,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
        );
  }

  @override
  bool get restoreInitialPosition => false;

  @override
  int get restoredTweetId => 0;
}
