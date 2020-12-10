import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/circle_button.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_layout.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:video_player/video_player.dart';

class ComposeTweetMedia extends StatefulWidget {
  const ComposeTweetMedia(this.bloc);

  final ComposeBloc bloc;

  @override
  _ComposeTweetMediaState createState() => _ComposeTweetMediaState();
}

class _ComposeTweetMediaState extends State<ComposeTweetMedia> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _initController();
  }

  @override
  void didUpdateWidget(ComposeTweetMedia oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initController();
  }

  void _initController() {
    if (widget.bloc.hasVideo) {
      if (_controller == null ||
          !_controller.dataSource.contains(widget.bloc.media.first.path)) {
        _controller = VideoPlayerController.file(
          File(widget.bloc.media.first.path),
        )..initialize().then((_) => setState(() {}));
      }
    } else {
      _controller = null;
    }
  }

  Widget _buildImages() {
    return TweetImagesLayout(
      children: widget.bloc.media
          .map((PlatformFile imageFile) => Image.file(
                File(imageFile.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ))
          .toList(),
    );
  }

  Widget _buildGif() {
    return TweetImagesLayout(
      children: <Widget>[
        Image.file(
          File(widget.bloc.media.first.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ],
    );
  }

  Widget _buildVideo() {
    return ClipRRect(
      key: ValueKey<VideoPlayerController>(_controller),
      borderRadius: kDefaultBorderRadius,
      child: HarpyVideoPlayer.fromController(
        _controller,
        allowVerticalOverflow: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    double aspectRatio;

    switch (widget.bloc.mediaType) {
      case MediaType.image:
        child = _buildImages();
        break;
      case MediaType.gif:
        child = _buildGif();
        break;
      case MediaType.video:
        child = _buildVideo();
        aspectRatio = _controller.value?.aspectRatio ?? 16 / 9;
        break;
      default:
        child = const SizedBox();
        break;
    }

    return Padding(
      padding: DefaultEdgeInsets.all(),
      child: Stack(
        children: <Widget>[
          TweetMediaLayout(
            isImage: !widget.bloc.hasVideo,
            videoAspectRatio: aspectRatio,
            child: child,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(defaultSmallPaddingValue),
              child: CircleButton(
                color: Colors.black45,
                onTap: () => widget.bloc.add(const ClearTweetMediaEvent()),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
