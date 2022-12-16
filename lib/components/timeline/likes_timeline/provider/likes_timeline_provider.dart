import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final likesTimelineProvider = StateNotifierProvider.autoDispose
    .family<LikesTimelineNotifier, TimelineState, String>(
  (ref, userId) {
    ref.cacheFor(const Duration(minutes: 15));

    return LikesTimelineNotifier(
      ref: ref,
      twitterApi: ref.watch(twitterApiV1Provider),
      userId: userId,
    );
  },
  name: 'LikesTimelineProvider',
);

class LikesTimelineNotifier extends TimelineNotifier {
  LikesTimelineNotifier({
    required super.ref,
    required super.twitterApi,
    required String userId,
  }) : _userId = userId {
    // TODO: remove when refactoring timeline notifier
    if (!isTest) loadInitial();
  }

  final String _userId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.tweetService.listFavorites(
      userId: _userId,
      count: 200,
      sinceId: sinceId,
      maxId: maxId,
    );
  }
}
