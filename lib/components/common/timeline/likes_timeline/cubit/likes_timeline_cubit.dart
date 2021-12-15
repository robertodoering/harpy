import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Returns the likes timeline for the authenticated user when [handle] `null`.
class LikesTimelineCubit extends TimelineCubit {
  LikesTimelineCubit({
    required this.handle,
  }) {
    loadInitial();
  }

  final String? handle;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().tweetService.listFavorites(
          screenName: handle,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
        );
  }
}
