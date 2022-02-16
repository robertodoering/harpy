import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final likesTimelineProvider = StateNotifierProvider.autoDispose
    .family<LikesTimelineNotifier, TimelineState, String>(
  LikesTimelineNotifier.new,
  name: 'LikesTimelineProvider',
);

class LikesTimelineNotifier extends TimelineNotifier {
  LikesTimelineNotifier(this._ref, this._handle) : super(ref: _ref) {
    loadInitial();
  }

  final Ref _ref;
  final String _handle;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _ref.read(twitterApiProvider).tweetService.listFavorites(
          screenName: _handle,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
        );
  }
}
