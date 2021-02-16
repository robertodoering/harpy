import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/circle_button.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_layout.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:video_player/video_player.dart';

class ComposeTweetMedia extends StatefulWidget {
  const ComposeTweetMedia();

  @override
  _ComposeTweetMediaState createState() => _ComposeTweetMediaState();
}

class _ComposeTweetMediaState extends State<ComposeTweetMedia> {
  VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initController();
  }

  @override
  void didUpdateWidget(ComposeTweetMedia oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initController();
  }

  Future<void> _initController() async {
    final ComposeBloc bloc = context.read<ComposeBloc>();
    final ComposeState state = bloc.state;

    if (state.hasVideo) {
      final bool newVideo = _controller != null &&
          !_controller.dataSource.contains(state.media.first.path);

      if (_controller == null || newVideo) {
        try {
          if (newVideo) {
            await _controller.dispose();
          }

          _controller = VideoPlayerController.file(
            File(state.media.first.path),
          );

          await _controller.initialize();

          if (_controller.value.duration > const Duration(seconds: 140)) {
            // video too long
            bloc.add(const ClearComposedTweet());
            app<MessageService>().show(
              'video must be shorter than 140 seconds',
            );
          } else if (_controller.value.duration <
              const Duration(milliseconds: 500)) {
            // video too short
            bloc.add(const ClearComposedTweet());
            app<MessageService>().show('video must be longer than 0.5 seconds');
          } else {
            setState(() {});
          }
        } catch (e) {
          // invalid video
          bloc.add(const ClearComposedTweet());
          app<MessageService>().show('invalid video');
        }
      }
    } else if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }

  Widget _buildImages(ComposeState state) {
    return TweetImagesLayout(
      children: state.media
          .map((PlatformFile imageFile) => Image.file(
                File(imageFile.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ))
          .toList(),
    );
  }

  Widget _buildGif(ComposeState state) {
    return TweetImagesLayout(
      children: <Widget>[
        Image.file(
          File(state.media.first.path),
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
    final ComposeBloc bloc = context.watch<ComposeBloc>();
    final ComposeState state = bloc.state;

    Widget child;
    double aspectRatio;

    switch (state.type) {
      case MediaType.image:
        child = _buildImages(state);
        break;
      case MediaType.gif:
        child = _buildGif(state);
        break;
      case MediaType.video:
        child = _buildVideo();
        aspectRatio = _controller?.value?.aspectRatio ?? 16 / 9;
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
            isImage: !state.hasVideo,
            videoAspectRatio: aspectRatio,
            child: child,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(defaultSmallPaddingValue),
              child: CircleButton(
                color: Colors.black45,
                onTap: () => bloc.add(const ClearComposedTweet()),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
