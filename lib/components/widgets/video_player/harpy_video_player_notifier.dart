import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

part 'harpy_video_player_notifier.freezed.dart';

final harpyVideoPlayerProvider = StateNotifierProvider.autoDispose.family<
    HarpyVideoPlayerNotifier, HarpyVideoPlayerState, HarpyVideoPlayerArguments>(
  (ref, arguments) {
    final handler = ref.watch(harpyVideoPlayerHandlerProvider);

    final notifier = HarpyVideoPlayerNotifier(
      urls: arguments.urls,
      autoplay: arguments.autoplay,
      loop: arguments.loop,
    );

    handler.add(notifier);

    ref.onDispose(() => handler.remove(notifier));

    return notifier;
  },
  name: 'HarpyVideoPlayerProvider',
);

class HarpyVideoPlayerNotifier extends StateNotifier<HarpyVideoPlayerState> {
  HarpyVideoPlayerNotifier({
    required BuiltMap<String, String> urls,
    required bool autoplay,
    required bool loop,
  })  : _urls = urls,
        _autoplay = autoplay,
        _loop = loop,
        super(
          autoplay
              ? const HarpyVideoPlayerState.loading()
              : const HarpyVideoPlayerState.uninitialized(),
        ) {
    _quality = urls.keys.first;

    _controller = VideoPlayerController.network(
      urls.values.first,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    if (autoplay) initialize();
  }

  final BuiltMap<String, String> _urls;
  final bool _autoplay;
  final bool _loop;

  late String _quality;

  late VideoPlayerController _controller;
  VideoPlayerController get controller => _controller;

  void _controllerListener() {
    if (_controller.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }

    if (!_controller.value.isInitialized) {
      state = const HarpyVideoPlayerState.uninitialized();
    } else if (_controller.value.hasError) {
      state = HarpyVideoPlayerState.error(_controller.value.errorDescription!);
    } else {
      state = HarpyVideoPlayerState.data(
        quality: _quality,
        qualities: _urls.keys.toBuiltList(),
        isBuffering: _controller.value.isBuffering,
        isPlaying: _controller.value.isPlaying,
        isMuted: _controller.value.volume == 0,
        position: _controller.value.position,
        duration: _controller.value.duration,
      );
    }
  }

  Future<void> initialize() async {
    state = const HarpyVideoPlayerState.loading();

    await _controller
        .initialize()
        .then((_) => _controller.addListener(_controllerListener))
        .then((_) async => _loop ? _controller.setLooping(_loop) : null)
        .then((_) => togglePlayback())
        .handleError(logErrorHandler);
  }

  Future<void> togglePlayback() {
    return _controller.value.isPlaying
        ? _controller.pause()
        : _controller.play();
  }

  Future<void> toggleMute() {
    return _controller.value.volume == 0
        ? _controller.setVolume(1)
        : _controller.setVolume(0);
  }

  Future<void> forward() async {
    final position = await _controller.position;

    if (position != null) {
      return _controller.seekTo(position + const Duration(seconds: 5));
    }
  }

  Future<void> rewind() async {
    final position = await _controller.position;

    if (position != null) {
      return _controller.seekTo(position - const Duration(seconds: 5));
    }
  }

  Future<void> changeQuality(String quality) async {
    final url = _urls[quality];

    if (url != null) {
      final position = await _controller.position;

      await _controller.dispose().handleError(logErrorHandler);

      _controller = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      // TODO: might have to reyield state with new quality
      _quality = quality;

      await _controller
          .initialize()
          .then((_) => _controller.addListener(_controllerListener))
          .then(
            (_) async => position != null ? _controller.seekTo(position) : null,
          )
          .handleError(logErrorHandler);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@freezed
class HarpyVideoPlayerState with _$HarpyVideoPlayerState {
  const factory HarpyVideoPlayerState.uninitialized() =
      HarpyVideoPlayerStateUninitialized;

  const factory HarpyVideoPlayerState.loading() = HarpyVideoPlayerStateLoading;

  const factory HarpyVideoPlayerState.error(String error) =
      HarpyVideoPlayerStateError;

  const factory HarpyVideoPlayerState.data({
    required String quality,
    required BuiltList<String> qualities,
    required bool isBuffering,
    required bool isPlaying,
    required bool isMuted,
    required Duration position,
    required Duration duration,
  }) = HarpyVideoPlayerStateData;
}
