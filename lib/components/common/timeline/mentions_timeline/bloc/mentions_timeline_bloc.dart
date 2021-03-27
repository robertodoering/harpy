import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mentions_timeline_event.dart';
part 'mentions_timeline_state.dart';

class MentionsTimelineBloc
    extends Bloc<MentionsTimelineEvent, MentionsTimelineState> {
  MentionsTimelineBloc() : super(const MentionsTimelineInitial());

  @override
  Stream<MentionsTimelineState> mapEventToState(
    MentionsTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
