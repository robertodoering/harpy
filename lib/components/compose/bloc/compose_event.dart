import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_state.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:mime_type/mime_type.dart';

@immutable
abstract class ComposeEvent {
  const ComposeEvent();

  Stream<ComposeState> applyAsync({
    ComposeState currentState,
    ComposeBloc bloc,
  });
}

/// Opens a [FilePicker] for selecting media files.
///
/// Selected files will be verified and added to the [ComposeBloc.media].
class PickTweetMediaEvent extends ComposeEvent {
  const PickTweetMediaEvent();

  void _addImages(ComposeBloc bloc, FilePickerResult result) {
    List<PlatformFile> newImages = List<PlatformFile>.from(result.files);

    if (bloc.hasImages) {
      newImages = List<PlatformFile>.from(bloc.media)..addAll(newImages);
    }

    if (newImages.length > 4) {
      app<MessageService>().show('Only up to 4 images can be attached');
      newImages = newImages.sublist(0, 4);
    }

    bloc.media = newImages;
  }

  void _addGif(ComposeBloc bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('Only one gif can be attached');
    }

    bloc.media = <PlatformFile>[result.files.first];
  }

  void _addVideo(ComposeBloc bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('Only one video can be attached');
    }

    bloc.media = <PlatformFile>[result.files.first];
  }

  @override
  Stream<ComposeState> applyAsync({
    ComposeState currentState,
    ComposeBloc bloc,
  }) async* {
    final FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      if (result.files.every(
        (PlatformFile file) => findMediaType(file.path) == MediaType.image,
      )) {
        _addImages(bloc, result);
      } else if (result.files.every(
        (PlatformFile file) => findMediaType(file.path) == MediaType.gif,
      )) {
        _addGif(bloc, result);
      } else if (result.files.every(
        (PlatformFile file) => findMediaType(file.path) == MediaType.video,
      )) {
        _addVideo(bloc, result);
      } else {
        app<MessageService>().show('Invalid selection\n'
            'Add up to 4 images, 1 gif or 1 video');
      }

      yield UpdatedComposeTweetState();
    }
  }
}

class ClearTweetMediaEvent extends ComposeEvent {
  const ClearTweetMediaEvent();

  @override
  Stream<ComposeState> applyAsync({
    ComposeState currentState,
    ComposeBloc bloc,
  }) async* {
    bloc.media.clear();

    yield UpdatedComposeTweetState();
  }
}

enum MediaType {
  image,
  gif,
  video,
}

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
