import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rby/rby.dart';
import 'package:video_player/video_player.dart';

// FIXME: make use of the `VideoPlayerNotifier` with a
//  `StaticVideoPlayerOverlay` in the `ComposeVideo`

class ComposeVideo extends StatefulWidget {
  const ComposeVideo({
    required this.media,
  });

  final PlatformFile media;

  @override
  State<ComposeVideo> createState() => _ComposeVideoState();
}

class _ComposeVideoState extends State<ComposeVideo> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(
      File(widget.media.path!),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..addListener(() {
        if (mounted) setState(() {});
      });

    _initialize();
  }

  Future<void> _initialize() async {
    await _controller
        .initialize()
        .then((_) => _controller.play())
        .handleError(logErrorHandler);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _controller.value.isPlaying ? _controller.pause : _controller.play,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: RbyAnimatedSwitcher(
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
