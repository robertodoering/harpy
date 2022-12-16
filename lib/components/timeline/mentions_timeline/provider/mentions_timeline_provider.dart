import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final mentionsTimelineProvider = StateNotifierProvider.autoDispose<
    MentionsTimelineNotifier, TimelineState<bool>>(
  (ref) {
    ref.cacheFor(const Duration(minutes: 15));

    return MentionsTimelineNotifier(
      ref: ref,
      twitterApi: ref.watch(twitterApiV1Provider),
    );
  },
  name: 'MentionsTimelineProvider',
);

class MentionsTimelineNotifier extends TimelineNotifier<bool> {
  MentionsTimelineNotifier({
    required super.ref,
    required super.twitterApi,
  });

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return twitterApi.timelineService.mentionsTimeline(
      count: 200,
      maxId: maxId,
      sinceId: sinceId,
    );
  }

  @override
  bool? buildCustomData(BuiltList<LegacyTweetData> tweets) {
    final newId = int.tryParse(tweets.first.originalId);
    final lastId =
        ref.read(tweetVisibilityPreferencesProvider).lastViewedMention;

    return newId != null && lastId < newId;
  }

  void updateViewedMentions() {
    log.fine('updating viewed mentions');

    final currentState = state;

    if (currentState is TimelineStateData<bool> &&
        currentState.tweets.isNotEmpty) {
      final id = int.tryParse(currentState.tweets.first.originalId);

      if (id != null) {
        ref.read(tweetVisibilityPreferencesProvider).lastViewedMention = id;

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
