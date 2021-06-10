import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'replies_event.dart';
part 'replies_state.dart';

/// Handles loading replies for a tweet.
///
/// If the tweet itself is also a reply, the parent tweets will also be
/// requested.
class RepliesBloc extends Bloc<RepliesEvent, RepliesState> {
  RepliesBloc(this.tweet) : super(const LoadingReplies()) {
    add(const LoadReplies());
  }

  /// The original tweet which to show replies for.
  final TweetData tweet;

  @override
  Stream<RepliesState> mapEventToState(
    RepliesEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
