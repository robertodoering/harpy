import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

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
