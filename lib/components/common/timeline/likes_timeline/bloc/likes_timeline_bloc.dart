import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'likes_timeline_event.dart';
part 'likes_timeline_state.dart';

class LikesTimelineBloc extends Bloc<LikesTimelineEvent, LikesTimelineState>
    with RequestLock {
  LikesTimelineBloc({
    required this.screenName,
  }) : super(const LikesTimelineInitial()) {
    on<LikesTimelineEvent>((event, emit) => event.handle(this, emit));
    add(const RequestLikesTimeline());
  }

  final String? screenName;

  /// Completes when older tweets for the timeline have been requested using
  /// [RequestOlderLikesTimeline].
  Completer<void> requestOlderCompleter = Completer<void>();
}
