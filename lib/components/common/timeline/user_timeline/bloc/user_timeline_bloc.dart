import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'user_timeline_event.dart';
part 'user_timeline_state.dart';

class UserTimelineBloc extends Bloc<UserTimelineEvent, UserTimelineState>
    with RequestLock {
  UserTimelineBloc({
    required this.screenName,
  }) : super(const UserTimelineInitial()) {
    on<UserTimelineEvent>((event, emit) => event.handle(this, emit));
    add(const RequestUserTimeline());
  }

  final String? screenName;

  /// Completes when the user timeline has been requested using the
  /// [RequestUserTimeline] event.
  Completer<void> requestTimelineCompleter = Completer<void>();

  /// Completes when older tweets for the timeline have been requested using
  /// [RequestOlderUserTimeline].
  Completer<void> requestOlderCompleter = Completer<void>();
}
