import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/shared/media/media_dialog.dart';
import 'package:harpy/components/shared/media/twitter_video_player.dart';
import 'package:harpy/components/shared/routes.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatefulWidget {
  final List<TwitterMedia> media;

  const CollapsibleMedia(this.media);

  // todo: instead of using a ExpansionTile, build own widget where the expand
  // icon is stacked on the media, so the title of the ExpansionTile doesn't
  // take up so much space

  @override
  CollapsibleMediaState createState() {
    return new CollapsibleMediaState();
  }
}

class CollapsibleMediaState extends State<CollapsibleMedia> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.media.any((media) => media.type == video)
                ? double.infinity // todo: limit to screen height
                : 250.0,
          ),
          child: _buildMediaLayout(context),
        ),
      ],
    );
  }

  /// Builds the [TwitterMedia] in a layout for max. 4 [TwitterMedia].
  ///
  /// There can be a max of 4 [TwitterMedia] for type [photo] or 1 for type
  /// [animatedGif] and [video].
  Widget _buildMediaLayout(BuildContext context) {
    final double padding = 2.0;

    if (widget.media.length == 1) {
      return Row(
        children: <Widget>[
          _buildMediaWidget(widget.media[0], context),
        ],
      );
    } else if (widget.media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(widget.media[0], context),
          SizedBox(width: padding),
          _buildMediaWidget(widget.media[1], context),
        ],
      );
    } else if (widget.media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(widget.media[0], context),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(widget.media[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(widget.media[2], context),
              ],
            ),
          ),
        ],
      );
    } else if (widget.media.length == 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(widget.media[0], context),
                SizedBox(height: padding),
                _buildMediaWidget(widget.media[2], context),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(widget.media[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(widget.media[3], context),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildMediaWidget(TwitterMedia media, BuildContext context) {
    Widget mediaWidget;

    int index = widget.media.indexOf(media);
    String heroTag = media.mediaUrl + "$index";
    GestureTapCallback tapCallback;

    if (media.type == photo) {
      // cached network image
      mediaWidget = CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );

      tapCallback = () => _showMediaGallery(index);
    } else if (media.type == animatedGif) {
      var key = GlobalKey<TwitterGifPlayerState>();

      // twitter gif player
      mediaWidget = TwitterGifPlayer(
        key: key,
        media: media,
        onShowFullscreen: () => _showGifFullscreen(key, media),
        onHideFullscreen: (context) => Navigator.maybePop(context),
      );
    } else if (media.type == video) {
      var key = GlobalKey<TwitterVideoPlayerState>();

      // twitter video player
      mediaWidget = TwitterVideoPlayer(
        key: key,
        media: media,
        onShowFullscreen: () => _showVideoFullscreen(key, media),
        onHideFullscreen: (context) => Navigator.maybePop(context),
      );
    }

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: GestureDetector(
          onTap: tapCallback,
          child: Hero(
            tag: heroTag,
            placeholderBuilder: (context, widget) => widget,
            child: mediaWidget,
          ),
        ),
      ),
    );
  }

  void _showMediaGallery(int initialIndex) {
    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return PhotoMediaDialog(media: widget.media, index: initialIndex);
      },
    ));
  }

  void _showVideoFullscreen(
    GlobalKey<TwitterVideoPlayerState> key,
    TwitterMedia media,
  ) {
    Navigator.of(context).push(
      HeroDialogRoute(builder: (context) {
        return Center(
          child: TwitterVideoPlayer(
            media: media,
            fullscreen: true,
            onHideFullscreen: (context) => Navigator.maybePop(context),
            controller: key.currentState.controller,
            initializing: key.currentState.initializing,
          ),
        );
      }),
    );
  }

  void _showGifFullscreen(
    GlobalKey<TwitterGifPlayerState> key,
    TwitterMedia media,
  ) {
    Navigator.of(context).push(
      HeroDialogRoute(builder: (context) {
        return Center(
          child: TwitterGifPlayer(
            media: media,
            fullscreen: true,
            onHideFullscreen: (context) => Navigator.maybePop(context),
            controller: key.currentState.controller,
            initializing: key.currentState.initializing,
          ),
        );
      }),
    );
  }
}
