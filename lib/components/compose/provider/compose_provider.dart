import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'compose_provider.freezed.dart';

final composeProvider =
    StateNotifierProvider.autoDispose<ComposeNotifier, ComposeState>(
  (ref) => ComposeNotifier(ref: ref),
  name: 'ComposeProvider',
);

class ComposeNotifier extends StateNotifier<ComposeState> {
  ComposeNotifier({
    required Ref ref,
  })  : _ref = ref,
        super(ComposeState());

  final Ref _ref;

  void initialize({
    LegacyTweetData? parentTweet,
    LegacyTweetData? quotedTweet,
  }) {
    state = ComposeState(
      parentTweet: parentTweet,
      quotedTweet: quotedTweet,
    );
  }

  void clear() {
    state = state.copyWith(media: null, type: null);
  }

  Future<void> pickMedia() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.media, allowMultiple: true)
        .handleError(logErrorHandler);

    if (result != null && result.files.isNotEmpty) {
      if (result.pickedImages) {
        _addImages(result);
      } else if (result.pickedGifs) {
        _addGif(result);
      } else if (result.pickedVideos) {
        _addVideo(result);
      } else {
        _ref.read(messageServiceProvider).showText(
              'invalid selection\n'
              'add up to 4 images, 1 gif or 1 video',
            );
      }
    }
  }

  void _addImages(FilePickerResult result) {
    var newMedia = List.of(result.files);

    if (state.type == MediaType.image) {
      // remove duplicates of already existing media
      newMedia.removeWhere(
        (image) =>
            state.media?.any((media) => media.path == image.path) ?? false,
      );

      newMedia = [...?state.media, ...newMedia];
    }

    if (newMedia.length > 4) {
      _ref.read(messageServiceProvider).showText(
            'only up to 4 images can be attached',
          );

      newMedia = newMedia.sublist(0, 4);
    }

    state = state.copyWith(
      media: newMedia.toBuiltList(),
      type: MediaType.image,
    );
  }

  void _addGif(FilePickerResult result) {
    if (result.files.length > 1) {
      _ref
          .read(messageServiceProvider)
          .showText('only one gif can be attached');
    } else {
      state = state.copyWith(
        media: [result.files.single].toBuiltList(),
        type: MediaType.gif,
      );
    }
  }

  void _addVideo(FilePickerResult result) {
    if (result.files.length > 1) {
      _ref
          .read(messageServiceProvider)
          .showText('only one video can be attached');
    } else {
      state = state.copyWith(
        media: [result.files.single].toBuiltList(),
        type: MediaType.video,
      );
    }
  }
}

@freezed
class ComposeState with _$ComposeState {
  factory ComposeState({
    LegacyTweetData? parentTweet,
    LegacyTweetData? quotedTweet,
    BuiltList<PlatformFile>? media,
    MediaType? type,
  }) = _ComposeState;

  ComposeState._();

  late final hasMedia = media != null && media!.isNotEmpty;
}

extension on FilePickerResult {
  bool get pickedImages => files.every(
        (file) => mediaTypeFromPath(file.path) == MediaType.image,
      );

  bool get pickedGifs => files.every(
        (file) => mediaTypeFromPath(file.path) == MediaType.gif,
      );

  bool get pickedVideos => files.every(
        (file) => mediaTypeFromPath(file.path) == MediaType.video,
      );
}
