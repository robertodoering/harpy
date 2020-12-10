import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:humanize/humanize.dart';

@immutable
abstract class PostTweetState {
  String get message => null;

  /// Whether the state has a humanly readable message.
  bool get hasMessage => message != null;
}

class InitialPostTweetStateState extends PostTweetState {}

/// The state when a video is being converted
class ConvertingVideoState extends PostTweetState {
  @override
  String get message => 'Converting video...';
}

class UploadingMediaState extends PostTweetState {
  UploadingMediaState({
    @required this.index,
    @required this.type,
  });

  /// The index of the media that is currently being uploaded.
  final int index;

  final MediaType type;

  @override
  String get message {
    switch (type) {
      case MediaType.image:
        return 'Uploading ${ordinal(index)} image...';
      case MediaType.gif:
        return 'Uploading gif...';
      case MediaType.video:
        return 'Uploading video...';
      default:
        return 'Uploading media...';
    }
  }
}

/// The event when the tweet is being sent to the twitter api.
class UpdatingStatusState extends PostTweetState {
  @override
  String get message => 'Sending tweet...';
}

/// The state when the tweet hast been posted successfully.
class StatusSuccessfullyUpdated extends PostTweetState {
  @override
  String get message => 'Tweet successfully sent!';
}

abstract class PostTweetError extends PostTweetState {}

/// The state when converting a video was not successful.
class ConvertingVideoError extends PostTweetError {
  @override
  String get message => 'Error converting video.';
}

/// The state when uploading the media was not successful.
class UploadMediaError extends PostTweetError {
  @override
  String get message => 'Error uploading media.';
}

/// The state when posting the tweet failed.
// todo: parse response error message
class UpdatingStatusError extends PostTweetError {
  @override
  String get message => 'Error sending tweet.';
}
