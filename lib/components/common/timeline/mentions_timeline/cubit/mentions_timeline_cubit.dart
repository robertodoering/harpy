import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class MentionsTimelineCubit extends TimelineCubit<bool> {
  /// The original id of the newest tweet that got requested.
  int? _newestMentionId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>()
        .timelineService
        .mentionsTimeline(
          count: 200,
          maxId: maxId,
          sinceId: sinceId,
        )
        .then((tweets) {
      if (maxId == null && tweets.isNotEmpty) {
        _newestMentionId = int.tryParse(tweets.first.idStr ?? '');
      }
      return tweets;
    });
  }

  @override
  bool? buildCustomData() {
    if (_newestMentionId != null) {
      return app<TweetVisibilityPreferences>().lastViewedMention <
          _newestMentionId!;
    } else {
      return null;
    }
  }

  @override
  Future<void> load({
    bool clearPrevious = false,
    bool viewedMentions = true,
  }) async {
    await super.load(clearPrevious: clearPrevious);

    if (viewedMentions) {
      updateViewedMentions();
    }
  }

  void updateViewedMentions() {
    log.fine('updating viewed mentions');

    final currentState = state;

    if (currentState is TimelineStateData<bool> &&
        currentState.tweets.isNotEmpty &&
        _newestMentionId != null) {
      app<TweetVisibilityPreferences>().lastViewedMention = _newestMentionId!;

      emit(currentState.copyWith(customData: false));
    }
  }
}

extension MentionsTimelineStateExtension on TimelineState<bool> {
  bool get hasNewMentions {
    if (this is TimelineStateData<bool>) {
      return (this as TimelineStateData<bool>).customData ?? false;
    } else {
      return false;
    }
  }
}
