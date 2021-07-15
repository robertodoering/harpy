import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds the video for the [model].
///
/// Used by the [HarpyVideoPlayerModel] to build the a [HarpyVideoPlayer] in
/// fullscreen.
class VideoFullscreen extends StatelessWidget {
  const VideoFullscreen(this.model);

  final HarpyVideoPlayerModel model;

  Widget _buildVideo() {
    return Stack(
      children: [
        VideoPlayer(model.controller!),
        DynamicVideoPlayerOverlay(model),
      ],
    );
  }

  /// Makes sure to pop the fullscreen using the [model] when using the back
  /// button to go back.
  Future<bool> _onWillPop() async {
    if (model.fullscreen) {
      // back button pressed
      model.toggleFullscreen();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // rotate the video depending on its aspect ratio and the current
    // orientation
    int quarterTurns;

    if (model.controller!.value.aspectRatio > 1) {
      quarterTurns = mediaQuery.orientation == Orientation.portrait ? 1 : 0;
    } else {
      quarterTurns = mediaQuery.orientation == Orientation.portrait ? 0 : 1;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Center(
          child: AspectRatio(
            aspectRatio: model.controller!.value.aspectRatio,
            child: ChangeNotifierProvider<HarpyVideoPlayerModel>.value(
              value: model,
              child: _buildVideo(),
            ),
          ),
        ),
      ),
    );
  }
}
