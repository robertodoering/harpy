import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final mentionsTimelineProvider =
    StateNotifierProvider<MentionsTimelineNotifier, TimelineState<bool>>(
  (ref) => MentionsTimelineNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiProvider),
  ),
  name: 'MentionsTimelineProvider',
);

class MentionsTimelineNotifier extends TimelineNotifier<bool> {
  MentionsTimelineNotifier({
    required super.ref,
    required super.twitterApi,
  }) : _read = ref.read;

  final Reader _read;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.timelineService.mentionsTimeline(
      count: 200,
      maxId: maxId,
      sinceId: sinceId,
    );
  }

  @override
  bool? buildCustomData(BuiltList<TweetData> tweets) {
    final newId = int.tryParse(tweets.first.originalId);
    final lastId = _read(tweetVisibilityPreferencesProvider).lastViewedMention;

    return newId != null && lastId < newId;
  }

  void updateViewedMentions() {
    log.fine('updating viewed mentions');

    final currentState = state;

    if (currentState is TimelineStateData<bool> &&
        currentState.tweets.isNotEmpty) {
      final id = int.tryParse(currentState.tweets.first.originalId);

      if (id != null) {
        _read(tweetVisibilityPreferencesProvider).lastViewedMention = id;

        state = currentState.copyWith(customData: false);
      }
    }
  }
}

extension MentionsTimelineStateExtension on TimelineState<bool> {
  bool get hasNewMentions => maybeMap(
        data: (data) => data.customData as bool? ?? false,
        orElse: () => false,
      );
}
