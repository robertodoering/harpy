import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Builds a [VideoPlayer] for an animated gif.
///
/// The video representing the gif will loop after initializing and play on tap.
class HarpyGifPlayer extends StatefulWidget {
  const HarpyGifPlayer.fromController(
    this.controller, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onGifTap,
    this.onGifLongPress,
    this.allowVerticalOverflow = false,
    this.compact = false,
  }) : model = null;

  const HarpyGifPlayer.fromModel(
    this.model, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onGifTap,
    this.onGifLongPress,
    this.allowVerticalOverflow = false,
    this.compact = false,
  }) : controller = null;

  final VideoPlayerController? controller;

  /// An optional url to a thumbnail that is built when the video is not
  /// initialized.
  final String? thumbnail;
  final double? thumbnailAspectRatio;

  /// Whether the gif should start playing automatically.
  final bool autoplay;

  final HarpyVideoPlayerModel? model;
  final OnVideoPlayerTap? onGifTap;
  final OnVideoPlayerLongPress? onGifLongPress;
  final bool allowVerticalOverflow;
  final bool compact;

  @override
  _HarpyGifPlayerState createState() => _HarpyGifPlayerState();
}

class _HarpyGifPlayerState extends State<HarpyGifPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.model == null) {
      _controller = widget.controller?..setLooping(true);
    } else {
      _controller = widget.model!.controller;
    }
  }

  @override
  void dispose() {
    if (widget.model == null) {
      _controller!.dispose();
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
      compact: widget.compact,
      initializing: model.initializing,
      onTap: model.initialize,
      onLongPress: widget.onGifLongPress,
    );
  }

  Widget _buildGif(HarpyVideoPlayerModel model) {
    Widget child = GestureDetector(
      onTap: widget.onGifTap == null
          ? model.togglePlayback
          : () => widget.onGifTap!(model),
      onLongPress: widget.onGifLongPress,
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );

    if (widget.allowVerticalOverflow) {
      child = OverflowBox(
        minHeight: 0,
        maxHeight: double.infinity,
        child: child,
      );
    }

    return GifPlayerOverlay(
      model,
      compact: widget.compact,
      child: child,
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget as Hero
        : toHeroContext.widget as Hero;

    final tween = BorderRadiusTween(
      begin: const BorderRadius.all(kRadius),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    final model = context.watch<HarpyVideoPlayerModel>();

    var child =
        !model.initialized ? _buildUninitialized(model) : _buildGif(model);

    if (widget.autoplay) {
      child = VideoAutoplay(
        child: child,
      );
    }

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
        value: widget.model!,
        builder: _builder,
      );
    } else {
      return ChangeNotifierProvider<HarpyVideoPlayerModel>(
        create: (_) => HarpyVideoPlayerModel(_controller),
        builder: _builder,
      );
    }
  }
}
