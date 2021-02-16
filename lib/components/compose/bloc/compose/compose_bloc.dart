import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:mime_type/mime_type.dart';

part 'compose_event.dart';
part 'compose_state.dart';

class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  ComposeBloc({
    this.inReplyToStatus,
  }) : super(const ComposeState());

  final TweetData inReplyToStatus;

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

// todo: move out of compose_bloc
enum MediaType {
  image,
  gif,
  video,
}

/// Uses [mime] to find the [MediaType] from a file path.
MediaType findMediaType(String path) {
  final String mimeType = mime(path);

  if (mimeType == null) {
    return null;
  } else if (mimeType.startsWith('video')) {
    return MediaType.video;
  } else if (mimeType == 'image/gif') {
    return MediaType.gif;
  } else if (mimeType.startsWith('image')) {
    return MediaType.image;
  } else {
    return null;
  }
}
