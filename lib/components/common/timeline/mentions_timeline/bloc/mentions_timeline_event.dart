part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineEvent extends Equatable {
  const MentionsTimelineEvent();

  Stream<MentionsTimelineState> applyAsync({
    MentionsTimelineState currentState,
    MentionsTimelineBloc bloc,
  });
}
