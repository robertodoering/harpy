part of 'compose_bloc.dart';

abstract class ComposeEvent {
  const ComposeEvent();

  const factory ComposeEvent.pickMedia() = _PickMedia;
  const factory ComposeEvent.clear() = _Clear;

  Future<void> handle(ComposeBloc bloc, Emitter emit);
}

/// Opens a [FilePicker] to add up to 4 images, one gif or one video to the
/// composed tweet.
class _PickMedia extends ComposeEvent {
  const _PickMedia();

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
      bloc!.add(_AddGif(file: result.files.first));
    }
  }

  void _addVideo(ComposeBloc? bloc, FilePickerResult result) {
    if (result.files.length > 1) {
      app<MessageService>().show('only one video can be attached');
    } else {
      bloc!.add(_AddVideo(file: result.files.first));
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
        .pickFiles(type: FileType.media, allowMultiple: true)
        .handleError(silentErrorHandler);

    if (result != null && result.files.isNotEmpty) {
      if (_pickedImages(result)) {
        bloc.add(_AddImage(files: result.files));
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

class _AddImage extends ComposeEvent {
  const _AddImage({
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
        media: newFiles.toBuiltList(),
        type: MediaType.image,
      ),
    );
  }
}

class _AddGif extends ComposeEvent {
  const _AddGif({
    required this.file,
  });

  final PlatformFile file;

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(
      ComposeState(
        media: BuiltList.of([file]),
        type: MediaType.gif,
      ),
    );
  }
}

class _AddVideo extends ComposeEvent {
  const _AddVideo({
    required this.file,
  });

  final PlatformFile file;

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(
      ComposeState(
        media: BuiltList.of([file]),
        type: MediaType.video,
      ),
    );
  }
}

class _Clear extends ComposeEvent {
  const _Clear();

  @override
  Future<void> handle(ComposeBloc bloc, Emitter emit) async {
    emit(ComposeState(media: BuiltList()));
  }
}
