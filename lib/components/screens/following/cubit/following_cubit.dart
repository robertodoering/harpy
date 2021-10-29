import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class FollowingCubit extends PaginatedUsersCubit {
  FollowingCubit({
    required this.userId,
  }) : super(const PaginatedState.loading()) {
    loadInitial();
  }

  final String userId;

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return app<TwitterApi>().userService.friendsList(
          userId: userId,
          cursor: cursor,
          skipStatus: true,
          count: 200,
        );
  }
}
