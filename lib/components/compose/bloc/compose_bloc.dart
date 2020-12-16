import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_event.dart';
import 'package:harpy/components/compose/bloc/compose_state.dart';
import 'package:mime_type/mime_type.dart';

class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  ComposeBloc() : super(InitialComposeTweetState());

  static ComposeBloc of(BuildContext context) => context.watch<ComposeBloc>();

  /// The selected media to be attached to the tweet.
  List<PlatformFile> media = <PlatformFile>[];

  /// Whether media has been attached to the tweet.
  bool get hasMedia => media.isNotEmpty;

  /// Whether the media only contains images.
  bool get hasImages => media.every(
        (PlatformFile file) => findMediaType(file.path) == MediaType.image,
      );

  /// Whether the media contains a single gif.
  bool get hasGif =>
      media.length == 1 && findMediaType(media.first.path) == MediaType.gif;

  /// Whether the media contains a single video.
  bool get hasVideo =>
      media.length == 1 && findMediaType(media.first.path) == MediaType.video;

  /// Returns the [MediaType] of the attached media or `null` if no media has
  /// been attached.
  MediaType get mediaType {
    if (hasImages) {
      return MediaType.image;
    } else if (hasGif) {
      return MediaType.gif;
    } else if (hasVideo) {
      return MediaType.video;
    } else {
      return null;
    }
  }

  @override
  Stream<ComposeState> mapEventToState(
    ComposeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}

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
