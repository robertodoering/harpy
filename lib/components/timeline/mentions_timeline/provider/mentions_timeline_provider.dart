import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final mentionsTimelineProvider = StateNotifierProvider.autoDispose<
    MentionsTimelineNotifier, TimelineState<bool>>(
  MentionsTimelineNotifier.new,
  name: 'MentionsTimelineProvider',
);

class MentionsTimelineNotifier extends TimelineNotifier<bool> {
  MentionsTimelineNotifier(this._ref) : super(ref: _ref);

  final Ref _ref;

  /// The original id of the newest tweet that got requested.
  int? _newestMentionId;

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _ref
        .read(twitterApiProvider)
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
  bool? buildCustomData() => _newestMentionId != null
      ? _ref.read(tweetVisibilityPreferencesProvider).lastViewedMention <
          _newestMentionId!
      : null;

  @override
  Future<void> load({
    bool clearPrevious = false,
    bool viewedMentions = true,
  }) async {
    await super.load(clearPrevious: clearPrevious);

    if (viewedMentions) updateViewedMentions();
  }

  void updateViewedMentions() {
    log.fine('updating viewed mentions');

    final currentState = state;

    if (currentState is TimelineStateData<bool> &&
        currentState.tweets.isNotEmpty &&
        _newestMentionId != null) {
      _ref.read(tweetVisibilityPreferencesProvider).lastViewedMention =
          _newestMentionId!;

      state = currentState.copyWith(customData: false);
    }
  }
}
