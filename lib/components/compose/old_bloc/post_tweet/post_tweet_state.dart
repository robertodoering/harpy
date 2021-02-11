import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/old_bloc/compose_bloc.dart';
import 'package:humanize/humanize.dart';

@immutable
abstract class PostTweetState {
  String get message => null;

  String get additionalInfo => null;

  /// Whether the state has a humanly readable message.
  bool get hasMessage => message != null;

  /// Whether additional info exists for this message.
  bool get hasAdditionalInfo => additionalInfo != null;
}

class InitialPostTweetStateState extends PostTweetState {}

/// The state when a video is being converted
class ConvertingVideoState extends PostTweetState {
  @override
  String get message => 'Preparing video...';

  @override
  String get additionalInfo => 'This may take a moment';
}

class UploadingMediaState extends PostTweetState {
  UploadingMediaState({
    @required this.index,
    @required this.multiple,
    @required this.type,
  });

  /// The index of the media that is currently being uploaded.
  final int index;

  final bool multiple;
  final MediaType type;

  @override
  String get message {
    switch (type) {
      case MediaType.image:
        return multiple
            ? 'Uploading ${ordinal(index + 1)} image...'
            : 'Uploading image...';
      case MediaType.gif:
        return 'Uploading gif...';
      case MediaType.video:
        return 'Uploading video...';
      default:
        return 'Uploading media...';
    }
  }

  @override
  String get additionalInfo => 'This may take a moment';
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
  String get message => 'Error preparing video.';

  @override
  String get additionalInfo => 'The video format may not be supported.';
}

/// The state when uploading the media was not successful.
class UploadMediaError extends PostTweetError {
  @override
  String get message => 'Error uploading media.';
}

/// The state when posting the tweet failed.
class UpdatingStatusError extends PostTweetError {
  UpdatingStatusError({
    this.errorMessage,
  });

  final String errorMessage;

  @override
  String get message => 'Error sending tweet.';

  @override
  String get additionalInfo {
    if (errorMessage != null) {
      return 'Twitter error message:\n'
          '$errorMessage';
    } else {
      return null;
    }
  }
}
