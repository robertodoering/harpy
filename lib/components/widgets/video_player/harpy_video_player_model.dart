import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

/// Actions that a user can take on a video.
enum HarpyVideoPlayerAction {
  play,
  pause,
  mute,
  unmute,
  fastForward,
  fastRewind,
}

/// Defines a callback that is called when an action is taken on a video.
typedef OnAction = void Function(HarpyVideoPlayerAction);

/// A [ChangeNotifier] handling changes to a [HarpyVideoPlayer].
class HarpyVideoPlayerModel extends ChangeNotifier {
  HarpyVideoPlayerModel(
    this.controller, {
    bool autoplay = false,
  }) {
    if (autoplay) {
      initialize();
    }
  }

  final VideoPlayerController? controller;

  /// Lists of listeners called whenever an action on the video has been taken.
  final List<OnAction> _actionListener = [];

  /// Whether the video has already been initialized.
  bool get initialized => controller!.value.isInitialized;

  /// Whether the [controller] is currently initializing the video.
  bool _initializing = false;
  bool get initializing => _initializing;

  /// Whether the video is currently playing.
  bool get playing => controller!.value.isPlaying;

  /// Whether the video has finished playing and has reached the end.
  bool get finished => position >= duration;

  /// Whether the volume for the video is `0`.
  bool get muted => controller!.value.volume == 0;

  /// The total duration of the video.
  Duration get duration => controller!.value.duration;

  /// The current position of the video.
  Duration get position => controller!.value.position;

  /// Whether the video is currently playing in fullscreen.
  bool _fullscreen = false;
  bool get fullscreen => _fullscreen;

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  /// Initializes the [controller].
  Future<void> initialize() async {
    _initializing = true;
    notifyListeners();

    try {
      await controller!.initialize();
      togglePlayback();
    } catch (e) {
      // video didn't load / ignore
    }

    _initializing = false;
    notifyListeners();
  }

  /// Plays or pauses the video.
  void togglePlayback({
    bool notify = true,
  }) {
    if (finished || !hasListeners) {
      // finished or if no listeners exist (already disposed)
      Wakelock.disable();
      return;
    }

    if (playing) {
      controller!.pause();
      if (notify) {
        _onAction(HarpyVideoPlayerAction.pause);
      }
      Wakelock.disable();
    } else {
      controller!.play();
      if (notify) {
        _onAction(HarpyVideoPlayerAction.play);
      }
      Wakelock.enable();
    }

    notifyListeners();
  }

  /// Seeks to the beginning and replays the video.
  void replay() {
    controller!.seekTo(Duration.zero);
    controller!.play();
    _onAction(HarpyVideoPlayerAction.play);

    notifyListeners();
  }

  /// Changes the volume to 0 or 1 to mute or unmute the video.
  void toggleMute() {
    if (controller!.value.volume == 0) {
      controller!.setVolume(1);
      _onAction(HarpyVideoPlayerAction.unmute);
    } else {
      controller!.setVolume(0);
      _onAction(HarpyVideoPlayerAction.mute);
    }

    notifyListeners();
  }

  /// Seeks the video 5 seconds forward.
  ///
  /// If the video is paused, it will also start playing.
  void fastForward() {
    if (!finished) {
      controller!
          .seekTo(controller!.value.position + const Duration(seconds: 5));

      _onAction(HarpyVideoPlayerAction.fastForward);

      if (!playing) {
        togglePlayback(notify: false);
      }
    }
  }

  /// Rewinds the video by 5 seconds.
  ///
  /// If the video is paused, it will also start playing.
  void fastRewind() {
    if (position > Duration.zero) {
      controller!
          .seekTo(controller!.value.position - const Duration(seconds: 5));

      _onAction(HarpyVideoPlayerAction.fastRewind);

      if (!playing) {
        togglePlayback(notify: false);
      }
    }
  }

  /// Fullscreens the video or exits the fullscreen video.
  void toggleFullscreen() {
    if (_fullscreen) {
      _popFullscreen();
    } else {
      _pushFullscreen();
    }
  }

  /// Fullscreens the video.
  ///
  /// The system ui overlay will be hidden while the video is played in
  /// fullscreen.
  void _pushFullscreen() {
    _fullscreen = true;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    app<HarpyNavigator>().push(
      HeroDialogRoute<void>(
        onBackgroundTap: toggleFullscreen,
        builder: (_) => VideoFullscreen(this),
      ),
    );
  }

  /// Exits the fullscreen video.
  ///
  /// The system ui overlays will be shown again.
  void _popFullscreen() {
    _fullscreen = false;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    if (hasListeners) {
      app<HarpyNavigator>().maybePop();
      notifyListeners();
    }
  }

  /// Adds the listener [onAction] to the [_actionListener] list.
  ///
  /// Listeners should get removes via [removeActionListener] when no longer
  /// needed.
  void addActionListener(OnAction onAction) {
    _actionListener.add(onAction);
  }

  /// Removes the listener [onAction] from the [_actionListener] list.
  void removeActionListener(OnAction onAction) {
    _actionListener.remove(onAction);
  }

  /// Calls the action listeners with the [action].
  void _onAction(HarpyVideoPlayerAction action) {
    for (final onAction in _actionListener) {
      onAction(action);
    }
  }
}
