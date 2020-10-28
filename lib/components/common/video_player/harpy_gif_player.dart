import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/overlay/gif_player_overlay.dart';
import 'package:harpy/components/common/video_player/video_thumbnail.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds a [VideoPlayer] for an animated gif.
///
/// The video representing the gif will loop after initializing and play on tap.
class HarpyGifPlayer extends StatefulWidget {
  const HarpyGifPlayer.fromUrl(
    this.url, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onGifTap,
    this.allowVerticalOverflow = false,
  }) : model = null;

  const HarpyGifPlayer.fromModel(
    this.model, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onGifTap,
    this.allowVerticalOverflow = false,
  }) : url = null;

  final String url;

  /// An optional url to a thumbnail that is built when the video is not
  /// initialized.
  final String thumbnail;
  final double thumbnailAspectRatio;

  /// Whether the gif should start playing automatically.
  final bool autoplay;

  final HarpyVideoPlayerModel model;
  final OnVideoPlayerTap onGifTap;
  final bool allowVerticalOverflow;

  @override
  _HarpyGifPlayerState createState() => _HarpyGifPlayerState();
}

class _HarpyGifPlayerState extends State<HarpyGifPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        widget.model?.controller ?? VideoPlayerController.network(widget.url)
          ..setLooping(true);
  }

  @override
  void dispose() {
    if (widget.model == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  /// Builds a [VideoThumbnail] that will start to initialize the gif when
  /// tapped.
  Widget _buildUninitialized(HarpyVideoPlayerModel model) {
    return VideoThumbnail(
      thumbnail: widget.thumbnail,
      aspectRatio: widget.thumbnailAspectRatio,
      icon: Icons.gif,
      initializing: model.initializing,
      onTap: model.initialize,
    );
  }

  Widget _buildGif(HarpyVideoPlayerModel model) {
    Widget child = GestureDetector(
      onTap: widget.onGifTap == null
          ? model.togglePlayback
          : () => widget.onGifTap(model),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );

    if (widget.allowVerticalOverflow) {
      child = OverflowBox(
        minHeight: 0,
        maxHeight: double.infinity,
        child: child,
      );
    }

    return GifPlayerOverlay(model, child: child);
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget
        : toHeroContext.widget;

    final BorderRadiusTween tween = BorderRadiusTween(
      begin: const BorderRadius.all(kDefaultRadius),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) => ClipRRect(
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    final HarpyVideoPlayerModel model = HarpyVideoPlayerModel.of(context);

    final Widget child =
        !model.initialized ? _buildUninitialized(model) : _buildGif(model);

    return Hero(
      tag: model,
      flightShuttleBuilder: _flightShuttleBuilder,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model != null) {
      return ChangeNotifierProvider<HarpyVideoPlayerModel>.value(
        value: widget.model,
        builder: _builder,
      );
    } else {
      return ChangeNotifierProvider<HarpyVideoPlayerModel>(
        create: (BuildContext context) => HarpyVideoPlayerModel(
          _controller,
          autoplay: false,
          // todo: fix autoplay not playing gif when scrolling too fast
          // add a visibility detector listener for tweet cards to start
          //   initializing and playing the video / gif. can also be used to
          //   autoplay videos (new setting)
          // autoplay: widget.autoplay,
        ),
        builder: _builder,
      );
    }
  }
}
