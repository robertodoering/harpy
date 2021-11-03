part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineState extends Equatable {
  const MentionsTimelineState();
}

extension MentionsTimelineExtension on MentionsTimelineState {
  bool get showLoading => this is MentionsTimelineLoading;

  bool get showNoMentionsFound => this is MentionsTimelineNoResults;

  bool get showMentionsError => this is MentionsTimelineFailure;

  bool get enableScroll => !showLoading;

  bool get hasMentions => timelineTweets.isNotEmpty;

  bool get hasNewMentions {
    if (this is MentionsTimelineResult) {
      return (this as MentionsTimelineResult).hasNewMentions;
    } else {
      return false;
    }
  }

  List<TweetData> get timelineTweets {
    if (this is MentionsTimelineResult) {
      return (this as MentionsTimelineResult).tweets;
    } else {
      return <TweetData>[];
    }
  }
}

class MentionsTimelineInitial extends MentionsTimelineState {
  const MentionsTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the mentions timeline is loading.
class MentionsTimelineLoading extends MentionsTimelineState {
  const MentionsTimelineLoading();

  @override
  List<Object> get props => <Object>[];
}

/// The state when the mentions were successfully requested.
class MentionsTimelineResult extends MentionsTimelineState {
  const MentionsTimelineResult({
    required this.tweets,
    required this.hasNewMentions,
    this.newestMentionId,
  });

  final List<TweetData> tweets;

  /// Whether new mentions exist since the user has last viewed their mentions.
  final bool hasNewMentions;

  /// The original id of the newest tweet.
  ///
  /// This can differ from the first tweet in [tweets] if the newest mention is
  /// a reply to another mention.
  final int? newestMentionId;

  @override
  List<Object?> get props => [
        tweets,
        hasNewMentions,
        newestMentionId,
      ];
}

/// The state when the mentions were successfully requested but no mentions
/// exist for the user.
class MentionsTimelineNoResults extends MentionsTimelineState {
  const MentionsTimelineNoResults();

  @override
  List<Object> get props => <Object>[];
}

/// The state when an error occurred while requesting the mentions timeline.
class MentionsTimelineFailure extends MentionsTimelineState {
  const MentionsTimelineFailure();

  @override
  List<Object> get props => <Object>[];
}
