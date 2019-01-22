import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/__old_stores/home_store.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/widgets/shared/media/media_expansion.dart';
import 'package:harpy/widgets/shared/media/twitter_video_player.dart';
import 'package:harpy/widgets/shared/routes.dart';
import 'package:harpy/widgets/shared/tweet/old_tweet_list.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of [TwitterMedia] that can be collapsed.
class OldCollapsibleMedia extends StatefulWidget {
  final Tweet tweet;

  const OldCollapsibleMedia({
    @required this.tweet,
  });

  @override
  OldCollapsibleMediaState createState() => OldCollapsibleMediaState();
}

class OldCollapsibleMediaState extends State<OldCollapsibleMedia> {
  Tweet get tweet => widget.tweet.retweetedStatus ?? widget.tweet;

  List<TwitterMedia> get _media => tweet.extended_entities.media;

  bool get _initiallyExpanded =>
      widget.tweet.harpyData.showMedia ?? true; // todo: get from settings

  @override
  Widget build(BuildContext context) {
    return OldMediaExpansion(
      initiallyExpanded: _initiallyExpanded,
      onExpansionChanged: _saveShowMediaState,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: _media.any((media) => media.type == photo)
              ? 250.0
              // max video height: screen height - appbar - padding
              : MediaQuery.of(context).size.height - 80 - 24,
        ),
        child: _buildMediaLayout(context),
      ),
    );
  }

  /// Builds the [TwitterMedia] in a layout for max. 4 [TwitterMedia].
  ///
  /// There can be a max of 4 [TwitterMedia] for type [photo] or 1 for type
  /// [animatedGif] and [video].
  Widget _buildMediaLayout(BuildContext context) {
    final double padding = 2.0;

    if (_media.length == 1) {
      return Row(
        children: <Widget>[
          _buildMediaWidget(_media[0], context),
        ],
      );
    } else if (_media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(_media[0], context),
          SizedBox(width: padding),
          _buildMediaWidget(_media[1], context),
        ],
      );
    } else if (_media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMediaWidget(_media[0], context),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(_media[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(_media[2], context),
              ],
            ),
          ),
        ],
      );
    } else if (_media.length == 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(_media[0], context),
                SizedBox(height: padding),
                _buildMediaWidget(_media[2], context),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _buildMediaWidget(_media[1], context),
                SizedBox(height: padding),
                _buildMediaWidget(_media[3], context),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  /// Builds a [CachedNetworkImage], [TwitterGifPlayer] or [TwitterVideoPlayer]
  /// for images, gifs and videos.
  Widget _buildMediaWidget(TwitterMedia media, BuildContext context) {
    Widget mediaWidget;

    int index = _media.indexOf(media);
    String heroTag = media.mediaUrl + "$index"; // todo: with tweet id
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
            child: mediaWidget ?? Container(),
          ),
        ),
      ),
    );
  }

  void _showMediaGallery(int initialIndex) {
//    Navigator.of(context).push(HeroDialogRoute(
//      builder: (context) {
//        return PhotoMediaDialog(media: _media, index: initialIndex);
//      },
//    ));
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

  void _saveShowMediaState(bool showing) {
    ListType type = InheritedTweetList.of(context).type;

    if (type == ListType.home) {
      showing
          ? HomeStore.showTweetMediaAction(widget.tweet)
          : HomeStore.hideTweetMediaAction(widget.tweet);
    } else if (type == ListType.user) {
      showing
          ? HomeStore.showTweetMediaAction(widget.tweet)
          : HomeStore.hideTweetMediaAction(widget.tweet);
    }
  }
}
