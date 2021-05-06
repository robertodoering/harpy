part of 'compose_bloc.dart';

abstract class ComposeEvent extends Equatable {
  const ComposeEvent();

  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  });
}

/// Opens a [FilePicker] to add up to 4 images, one gif or one video to the
/// composed tweet.
class PickTweetMediaEvent extends ComposeEvent {
  const PickTweetMediaEvent();

  @override
  List<Object> get props => <Object>[];

  bool _pickedImages(FilePickerResult result) {
    return result.files.every(
      (PlatformFile file) => findMediaType(file.path) == MediaType.image,
    );
  }

  bool _pickedGif(FilePickerResult result) {
    return result.files.every(
      (PlatformFile file) => findMediaType(file.path) == MediaType.gif,
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
      (PlatformFile file) => findMediaType(file.path) == MediaType.video,
    );
  }

  @override
  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  }) async* {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(
          type: FileType.media,
          allowMultiple: true,
        )
        // ignore exception
        .catchError((dynamic e) {});

    if (result != null && result.files.isNotEmpty) {
      if (_pickedImages(result)) {
        bloc!.add(AddImagesEvent(files: result.files));
      } else if (_pickedGif(result)) {
        _addGif(bloc, result);
      } else if (_pickedVideo(result)) {
        _addVideo(bloc, result);
      } else {
        app<MessageService>().show('invalid selection\n'
            'add up to 4 images, 1 gif or 1 video');
      }
    }
  }
}

class AddImagesEvent extends ComposeEvent {
  const AddImagesEvent({
    required this.files,
  });

  final List<PlatformFile> files;

  @override
  List<Object> get props => <Object>[
        files,
      ];

  void _removeDuplicates(List<PlatformFile> newFiles, ComposeState? state) {
    for (PlatformFile image in List<PlatformFile>.from(newFiles)) {
      if (state!.media.any(
        (PlatformFile existingImage) => existingImage.path == image.path,
      )) {
        // remove the duplicate image
        newFiles.removeWhere(
          (PlatformFile duplicate) => duplicate.path == image.path,
        );
      }
    }
  }

  @override
  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  }) async* {
    List<PlatformFile> newFiles = List<PlatformFile>.from(files);

    if (currentState!.hasImages) {
      _removeDuplicates(newFiles, currentState);

      newFiles = List<PlatformFile>.from(currentState.media)..addAll(newFiles);
    }

    if (newFiles.length > 4) {
      app<MessageService>().show('only up to 4 images can be attached');
      newFiles = newFiles.sublist(0, 4);
    }

    yield ComposeState(
      media: newFiles,
      type: MediaType.image,
    );
  }
}

class AddGifEvent extends ComposeEvent {
  const AddGifEvent({
    required this.file,
  });

  final PlatformFile file;

  @override
  List<Object> get props => <Object>[
        file,
      ];

  @override
  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  }) async* {
    yield ComposeState(
      media: <PlatformFile>[file],
      type: MediaType.gif,
    );
  }
}

class AddVideoEvent extends ComposeEvent {
  const AddVideoEvent({
    required this.file,
  });

  final PlatformFile file;

  @override
  List<Object> get props => <Object>[
        file,
      ];

  @override
  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  }) async* {
    yield ComposeState(
      media: <PlatformFile>[file],
      type: MediaType.video,
    );
  }
}

class ClearComposedTweet extends ComposeEvent {
  const ClearComposedTweet();

  @override
  List<Object> get props => <Object>[];

  @override
  Stream<ComposeState> applyAsync({
    ComposeState? currentState,
    ComposeBloc? bloc,
  }) async* {
    yield const ComposeState();
  }
}
