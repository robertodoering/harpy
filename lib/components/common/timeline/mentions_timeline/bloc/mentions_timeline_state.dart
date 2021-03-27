part of 'mentions_timeline_bloc.dart';

abstract class MentionsTimelineState extends Equatable {
  const MentionsTimelineState();
}

class MentionsTimelineInitial extends MentionsTimelineState {
  const MentionsTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}
