import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/compose/old_bloc/compose_bloc.dart';
import 'package:harpy/components/compose/old_bloc/compose_state.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';

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
/// Selected files will be handled and added to the [ComposeBloc.media].
///
/// A message will be shown when an invalid selection is made.
class PickTweetMediaEvent extends ComposeEvent {
  const PickTweetMediaEvent();

  void _addImages(ComposeBloc bloc, FilePickerResult result) {
    List<PlatformFile> newImages = List<PlatformFile>.from(result.files);

    if (bloc.hasImages) {
      // add the new images to the existing ones if it doesn't already exist

      // filter out any already existing images
      for (PlatformFile image in List<PlatformFile>.from(newImages)) {
        if (bloc.media.any(
            (PlatformFile existingImage) => existingImage.path == image.path)) {
          // remove the duplicate image
          newImages.removeWhere(
              (PlatformFile duplicate) => duplicate.path == image.path);
        }
      }

      newImages = List<PlatformFile>.from(bloc.media)..addAll(newImages);
    }

    if (newImages.length > 4) {
      app<MessageService>().show('only up to 4 images can be attached');
      newImages = newImages.sublist(0, 4);
    }

    bloc.media = newImages;
  }

  void _addGif(ComposeBloc bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('only one gif can be attached');
    }

    bloc.media = <PlatformFile>[result.files.first];
  }

  void _addVideo(ComposeBloc bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('only one video can be attached');
    }

    bloc.media = <PlatformFile>[result.files.first];
  }

  @override
  Stream<ComposeState> applyAsync({
    ComposeState currentState,
    ComposeBloc bloc,
  }) async* {
    final FilePickerResult result = await FilePicker.platform
        .pickFiles(
          type: FileType.media,
          allowMultiple: true,
        )
        // ignore exception
        .catchError((dynamic e) {});

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
        // todo: enable adding video when pub:flutter_ffmpeg gets fixed
        app<MessageService>().show('adding videos is temporarily disabled due'
            ' to an issue');
        // _addVideo(bloc, result);
      } else {
        app<MessageService>().show('invalid selection\n'
            'add up to 4 images, 1 gif or 1 video');
      }

      yield UpdatedComposeTweetState();
    }
  }
}

/// Removes the references to the previously attached media.
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
