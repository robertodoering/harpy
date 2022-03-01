import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

part 'video_player_notifier.freezed.dart';

final videoPlayerProvider = StateNotifierProvider.autoDispose
    .family<VideoPlayerNotifier, VideoPlayerState, VideoPlayerArguments>(
  (ref, arguments) {
    final handler = ref.watch(videoPlayerHandlerProvider);

    final notifier = VideoPlayerNotifier(
      urls: arguments.urls,
      autoplay: arguments.autoplay,
      loop: arguments.loop,
    );

    handler.add(notifier);

    ref.onDispose(() => handler.remove(notifier));

    return notifier;
  },
  name: 'VideoPlayerProvider',
);

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier({
    required BuiltMap<String, String> urls,
    required bool autoplay,
    required bool loop,
  })  : _urls = urls,
        _loop = loop,
        super(
          autoplay
              ? const VideoPlayerState.loading()
              : const VideoPlayerState.uninitialized(),
        ) {
    _quality = urls.keys.first;

    _controller = VideoPlayerController.network(
      urls.values.first,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    if (autoplay) initialize();
  }

  final BuiltMap<String, String> _urls;
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
      state = const VideoPlayerState.uninitialized();
    } else if (_controller.value.hasError) {
      state = VideoPlayerState.error(_controller.value.errorDescription!);
    } else {
      state = VideoPlayerState.data(
        quality: _quality,
        qualities: _urls,
        isBuffering: _controller.value.isBuffering,
        isPlaying: _controller.value.isPlaying,
        isMuted: _controller.value.volume == 0,
        isFinished: _controller.value.position >=
            _controller.value.duration - const Duration(milliseconds: 400),
        position: _controller.value.position,
        duration: _controller.value.duration,
      );
    }
  }

  Future<void> initialize() async {
    state = const VideoPlayerState.loading();

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

  Future<void> pause() {
    return _controller.pause();
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
      final volume = _controller.value.volume;
      final isPlaying = _controller.value.isPlaying;

      final oldController = _controller;

      final newController = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _quality = quality;

      await newController
          .initialize()
          .then(
            (_) async =>
                position != null ? newController.seekTo(position) : null,
          )
          .then((_) async => newController.setVolume(volume))
          .then(
            (_) async =>
                isPlaying ? newController.play() : newController.pause(),
          )
          .then((_) => newController.addListener(_controllerListener))
          .handleError(logErrorHandler);

      _controller = newController;

      await oldController.dispose().handleError(logErrorHandler);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState.uninitialized() =
      VideoPlayerStateUninitialized;

  const factory VideoPlayerState.loading() = VideoPlayerStateLoading;

  const factory VideoPlayerState.error(String error) = VideoPlayerStateError;

  const factory VideoPlayerState.data({
    required String quality,
    required BuiltMap<String, String> qualities,
    required bool isBuffering,
    required bool isPlaying,
    required bool isMuted,
    required bool isFinished,
    required Duration position,
    required Duration duration,
  }) = VideoPlayerStateData;
}
