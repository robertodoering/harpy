import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/common/video_player/harpy_video_fullscreen.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Actions that a user can take on a video.
enum HarpyVideoPlayerAction {
  play,
  pause,
  mute,
  unmute,
}

/// Defines a callback that is called when an action is taken on a video.
typedef OnAction = void Function(HarpyVideoPlayerAction);

/// A [ChangeNotifer] handling changes to a [HarpyVideoPlayer].
class HarpyVideoPlayerModel extends ChangeNotifier {
  HarpyVideoPlayerModel(this.controller);

  final VideoPlayerController controller;

  static HarpyVideoPlayerModel of(BuildContext context) =>
      Provider.of<HarpyVideoPlayerModel>(context);

  /// Lists of listeners called whenever an action on the video has been taken.
  final List<OnAction> _actionListener = <OnAction>[];

  /// Whether the video has already been initialized.
  bool get initialized => controller.value.initialized;

  /// Whether the [controller] is currently initializing the video.
  bool _initializing = false;
  bool get initializing => _initializing;

  /// Whether the video is currently playing.
  bool get playing => controller.value.isPlaying;

  /// Whether the video has finished playing and has reached the end.
  bool get finished =>
      position != null && duration != null && position >= duration;

  /// Whether the volume for the video is `0`.
  bool get muted => controller.value.volume == 0;

  /// The total duration of the video.
  Duration get duration => controller.value.duration;

  /// The current position of the video.
  Duration get position => controller.value.position;

  /// Whether the video is currently playing in fullscreen.
  bool _fullscreen = false;
  bool get fullscreen => _fullscreen;

  /// Initializes the [controller].
  Future<void> initialize() async {
    _initializing = true;
    notifyListeners();

    await controller.initialize();

    togglePlayback();

    _initializing = false;
    notifyListeners();
  }

  /// Plays or pauses the video.
  void togglePlayback() {
    if (finished) {
      return;
    }

    if (playing) {
      controller.pause();
      _onAction(HarpyVideoPlayerAction.pause);
    } else {
      controller.play();
      _onAction(HarpyVideoPlayerAction.play);
    }

    notifyListeners();
  }

  /// Seeks to the beginning and replays the video.
  void replay() {
    controller.seekTo(Duration.zero);
    controller.play();
    _onAction(HarpyVideoPlayerAction.play);

    notifyListeners();
  }

  /// Changes the volume to 0 or 1 to mute or unmute the video.
  void toggleMute() {
    if (controller.value.volume == 0) {
      controller.setVolume(1);
      _onAction(HarpyVideoPlayerAction.unmute);
    } else {
      controller.setVolume(0);
      _onAction(HarpyVideoPlayerAction.mute);
    }

    notifyListeners();
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
  ///
  /// The device orientation is determined by the aspect ratio of the video.
  void _pushFullscreen() {
    _fullscreen = true;

    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);

    if (controller.value.aspectRatio > 1) {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    app<HarpyNavigator>().state.push<void>(
          HeroDialogRoute<void>(
            onBackgroundTap: toggleFullscreen,
            builder: (BuildContext context) => HarpyVideoFullscreen(this),
          ),
        );
  }

  /// Exits the fullscreen video.
  ///
  /// The system ui overlays will be shown again.
  ///
  /// The device orientation is restored to allow for both portrait and
  /// landscape.
  void _popFullscreen() {
    _fullscreen = false;

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    app<HarpyNavigator>().state.maybePop();
    notifyListeners();
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
    for (OnAction onAction in _actionListener) {
      onAction(action);
    }
  }
}
