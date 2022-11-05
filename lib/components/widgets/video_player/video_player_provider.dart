import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

part 'video_player_provider.freezed.dart';

final videoPlayerProvider = StateNotifierProvider.autoDispose
    .family<VideoPlayerNotifier, VideoPlayerState, VideoPlayerArguments>(
  (ref, arguments) {
    final handler = ref.watch(videoPlayerHandlerProvider);

    final notifier = VideoPlayerNotifier(
      urls: arguments.urls,
      loop: arguments.loop,
      ref: ref,
      onInitialized: arguments.isVideo
          ? () => handler.act((notifier) => notifier.pause())
          : null,
    );

    if (arguments.isVideo) {
      handler.add(notifier);
      ref.onDispose(() => handler.remove(notifier));
    }

    return notifier;
  },
);

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier({
    required BuiltMap<String, String> urls,
    required bool loop,
    required Ref ref,
    VoidCallback? onInitialized,
  })  : assert(urls.isNotEmpty),
        _onInitialized = onInitialized,
        _urls = urls,
        _loop = loop,
        _ref = ref,
        super(const VideoPlayerState.uninitialized()) {
    _quality = urls.keys.first;

    _controller = VideoPlayerController.network(
      urls[_quality]!,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
  }

  final BuiltMap<String, String> _urls;
  final bool _loop;
  final VoidCallback? _onInitialized;
  final Ref _ref;

  late String _quality;

  late VideoPlayerController _controller;
  VideoPlayerController get controller => _controller;

  void _controllerListener() {
    if (!mounted) return;
    Wakelock.toggle(enable: _controller.value.isPlaying);

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
        isFinished: _controller.value.duration != Duration.zero &&
            _controller.value.position >=
                _controller.value.duration - const Duration(milliseconds: 800),
        position: _controller.value.position,
        duration: _controller.value.duration,
      );
    }
  }

  /// Starts loading the video and then plays it.
  Future<void> initialize({double volume = 1}) async {
    state = const VideoPlayerState.loading();

    final startVideoPlaybackMuted =
        _ref.read(mediaPreferencesProvider).startVideoPlaybackMuted;

    if (startVideoPlaybackMuted) {
      volume = 0;
    }

    await _controller
        .initialize()
        .then((_) => _controller.addListener(_controllerListener))
        .then((_) => _controller.setVolume(volume))
        .then((_) => _controller.setLooping(_loop))
        .then((_) => _onInitialized?.call())
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
    if (_quality == quality) return;

    final url = _urls[quality];

    if (url != null) {
      final position = await _controller.position;
      final volume = _controller.value.volume;
      final isPlaying = _controller.value.isPlaying;
      final isLooping = _controller.value.isLooping;

      final oldController = _controller;

      final controller = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _quality = quality;

      await controller
          .initialize()
          .then((_) => controller.seekTo(position ?? Duration.zero))
          .then((_) => controller.setVolume(volume))
          .then((_) => isPlaying ? controller.play() : controller.pause())
          .then((_) => controller.setLooping(isLooping))
          .then((_) => controller.addListener(_controllerListener))
          .handleError(logErrorHandler);

      _controller = controller;

      await oldController.dispose().handleError(logErrorHandler);
    }
  }

  @override
  void dispose() {
    Wakelock.disable();
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
