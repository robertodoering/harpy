import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'compose_event.dart';
part 'compose_state.dart';

class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  ComposeBloc({
    this.inReplyToStatus,
    this.quotedTweet,
  }) : super(const ComposeState());

  final TweetData inReplyToStatus;
  final TweetData quotedTweet;

  /// Whether the user is replying to an existing tweet.
  bool get isReplying => inReplyToStatus != null;

  String get hintText => isReplying ? 'tweet your reply' : "what's happening?";

  @override
  Stream<ComposeState> mapEventToState(
    ComposeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
