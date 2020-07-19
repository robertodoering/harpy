import 'package:flutter/material.dart';
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

class HarpyVideoPlayerModel extends ChangeNotifier {
  HarpyVideoPlayerModel(this.controller);

  final VideoPlayerController controller;

  static HarpyVideoPlayerModel of(BuildContext context) =>
      Provider.of<HarpyVideoPlayerModel>(context);

  /// Called whenever an action on the video has been taken.
  OnAction onAction;

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
    print('finished: $finished');
    print('position: $position');
    print('duration: $duration');

    if (finished) {
      return;
    }

    if (playing) {
      controller.pause();
      onAction?.call(HarpyVideoPlayerAction.pause);
    } else {
      controller.play();
      onAction?.call(HarpyVideoPlayerAction.play);
    }

    notifyListeners();
  }

  /// Seeks to the beginning and replays the video.
  void replay() {
    controller.seekTo(Duration.zero);
    controller.play();
    onAction?.call(HarpyVideoPlayerAction.play);

    notifyListeners();
  }

  /// Changes the volume to 0 or 1 to mute or unmute the video.
  void toggleMute() {
    if (controller.value.volume == 0) {
      controller.setVolume(1);
      onAction?.call(HarpyVideoPlayerAction.unmute);
    } else {
      controller.setVolume(0);
      onAction?.call(HarpyVideoPlayerAction.mute);
    }

    notifyListeners();
  }
}
