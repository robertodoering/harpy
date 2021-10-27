part of 'compose_bloc.dart';

abstract class ComposeEvent {
  const ComposeEvent();

  Future<void> handle(ComposeBloc bloc, Emitter emit);
}

/// Opens a [FilePicker] to add up to 4 images, one gif or one video to the
/// composed tweet.
class PickTweetMediaEvent extends ComposeEvent {
  const PickTweetMediaEvent();

  bool _pickedImages(FilePickerResult result) {
    return result.files.every(
      (file) => findMediaType(file.path) == MediaType.image,
    );
  }

  bool _pickedGif(FilePickerResult result) {
    return result.files.every(
      (file) => findMediaType(file.path) == MediaType.gif,
    );
  }

  void _addGif(ComposeBloc? bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('only one gif can be attached');
    } else {
      bloc!.add(AddGifEvent(file: result.files.first));
    }
  }

  void _addVideo(ComposeBloc? bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('only one video can be attached');
    } else {
      bloc!.add(AddVideoEvent(file: result.files.first));
    }
  }

  bool _pickedVideo(FilePickerResult result) {
    return result.files.every(
      (file) => findMediaType(file.path) == MediaType.video,
    );
  }

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    final result = await FilePicker.platform
        .pickFiles(
          type: FileType.media,
          allowMultiple: true,
        )
        // ignore exception
        .handleError((dynamic e, st) {});

    if (result != null && result.files.isNotEmpty) {
      if (_pickedImages(result)) {
        bloc.add(AddImagesEvent(files: result.files));
      } else if (_pickedGif(result)) {
        _addGif(bloc, result);
      } else if (_pickedVideo(result)) {
        _addVideo(bloc, result);
      } else {
        app<MessageService>().show(
          'invalid selection\n'
          'add up to 4 images, 1 gif or 1 video',
        );
      }
    }
  }
}

class AddImagesEvent extends ComposeEvent {
  const AddImagesEvent({
    required this.files,
  });

  final List<PlatformFile> files;

  void _removeDuplicates(List<PlatformFile> newFiles, ComposeState? state) {
    for (final image in List<PlatformFile>.from(newFiles)) {
      if (state!.media.any(
        (existingImage) => existingImage.path == image.path,
      )) {
        // remove the duplicate image
        newFiles.removeWhere(
          (duplicate) => duplicate.path == image.path,
        );
      }
    }
  }

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    var newFiles = List<PlatformFile>.from(files);

    if (bloc.state.hasImages) {
      _removeDuplicates(newFiles, bloc.state);

      newFiles = List.from(bloc.state.media)..addAll(newFiles);
    }

    if (newFiles.length > 4) {
      app<MessageService>().show('only up to 4 images can be attached');
      newFiles = newFiles.sublist(0, 4);
    }

    emit(
      ComposeState(
        media: newFiles,
        type: MediaType.image,
      ),
    );
  }
}

class AddGifEvent extends ComposeEvent {
  const AddGifEvent({
    required this.file,
  });

  final PlatformFile file;

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(
      ComposeState(
        media: <PlatformFile>[file],
        type: MediaType.gif,
      ),
    );
  }
}

class AddVideoEvent extends ComposeEvent {
  const AddVideoEvent({
    required this.file,
  });

  final PlatformFile file;

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(
      ComposeState(
        media: <PlatformFile>[file],
        type: MediaType.video,
      ),
    );
  }
}

class ClearComposedTweet extends ComposeEvent {
  const ClearComposedTweet();

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(const ComposeState());
  }
}
