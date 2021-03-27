part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineState extends Equatable {
  const MentionsTimelineState();
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
    @required this.tweets,
    @required this.newMentions,
  });

  final List<TweetData> tweets;

  /// The number of new tweet mentions since the last time the user loaded
  /// the mentions timeline.
  final int newMentions;

  @override
  List<Object> get props => <Object>[
        tweets,
        newMentions,
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
