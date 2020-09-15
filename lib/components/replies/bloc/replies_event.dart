import 'package:flutter/foundation.dart';
import 'package:harpy/components/replies/bloc/replies_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

@immutable
abstract class RepliesEvent {
  const RepliesEvent();

  Stream<RepliesState> applyAsync({
    RepliesState currentState,
    RepliesBloc bloc,
  });
}

/// Loads the replies for the [tweet].
///
/// If the [tweet] itself is a reply, the parent tweets will also be loaded.
class LoadRepliesEvent extends RepliesEvent {
  const LoadRepliesEvent(this.tweet);

  final TweetData tweet;

  @override
  Stream<RepliesState> applyAsync({
    RepliesState currentState,
    RepliesBloc bloc,
  }) {
    throw UnimplementedError();
  }
}
