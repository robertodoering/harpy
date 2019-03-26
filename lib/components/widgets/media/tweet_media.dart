import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/widgets/media/media_dialog.dart';
import 'package:harpy/components/widgets/media/media_gif_player.dart';
import 'package:harpy/components/widgets/media/media_video_player.dart';
import 'package:harpy/components/widgets/shared/custom_expansion_tile.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/media_model.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:scoped_model/scoped_model.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of [TwitterMedia] that can be collapsed.
class CollapsibleMedia extends StatefulWidget {
  @override
  CollapsibleMediaState createState() => CollapsibleMediaState();
}

class CollapsibleMediaState extends State<CollapsibleMedia> {
  MediaModel mediaModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    mediaModel ??= MediaModel(
      tweetModel: TweetModel.of(context),
      homeTimelineModel: HomeTimelineModel.of(context),
      mediaSettingsModel: MediaSettingsModel.of(context),
      connectivityService: serviceProvider.data.connectivityService,
    );

    return ScopedModel<MediaModel>(
      model: mediaModel,
      child: CustomExpansionTile(
        initiallyExpanded: mediaModel.initiallyShown,
        onExpansionChanged: mediaModel.saveShowMediaState,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaModel.media
                    .any((media) => media.type == photo || media.type == video)
                ? 250.0 // todo: maybe default to a 16:9 size for videos
                : double.infinity,
          ),
          child: _TweetMediaLayout(),
        ),
      ),
    );
  }
}

/// Builds the [_TweetMediaWidget] in a layout for max. 4 [TwitterMedia].
///
/// There can be a max of 4 [TwitterMedia] for type [photo] or 1 for type
/// [animatedGif] and [video].
class _TweetMediaLayout extends StatelessWidget {
  /// The padding between the [_TweetMediaWidget]s.
  static const double padding = 2.0;

  @override
  Widget build(BuildContext context) {
    final model = MediaModel.of(context);

    if (model.media.length == 1) {
      return Row(
        children: <Widget>[
          _TweetMediaWidget(0),
        ],
      );
    } else if (model.media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _TweetMediaWidget(0),
          SizedBox(width: padding),
          _TweetMediaWidget(1),
        ],
      );
    } else if (model.media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _TweetMediaWidget(0),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _TweetMediaWidget(1),
                SizedBox(height: padding),
                _TweetMediaWidget(2),
              ],
            ),
          ),
        ],
      );
    } else if (model.media.length == 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _TweetMediaWidget(0),
                SizedBox(height: padding),
                _TweetMediaWidget(2),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _TweetMediaWidget(1),
                SizedBox(height: padding),
                _TweetMediaWidget(3),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

/// Builds a [CachedNetworkImage], [MediaGifPlayer] or [MediaVideoPlayer] for
/// images, gifs and videos.
class _TweetMediaWidget extends StatelessWidget {
  const _TweetMediaWidget(this._index);

  final int _index;

  @override
  Widget build(BuildContext context) {
    final model = MediaModel.of(context);

    final TwitterMedia media = model.media[_index];

    Widget mediaWidget;

    GestureTapCallback tapCallback;

    if (media.type == photo) {
      // cached network image
      mediaWidget = CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );

      tapCallback = () => _showMediaGallery(context, model.media);
    } else if (media.type == animatedGif) {
      mediaWidget = MediaGifPlayer(
        mediaModel: model,
      );
    } else if (media.type == video) {
      mediaWidget = MediaVideoPlayer(
        mediaModel: model,
      );
    }

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: GestureDetector(
          onTap: tapCallback,
          child: Hero(
            tag: model.mediaHeroTag(_index),
            placeholderBuilder: (context, widget) => widget,
            child: mediaWidget ?? Container(),
          ),
        ),
      ),
    );
  }

  void _showMediaGallery(BuildContext context, List<TwitterMedia> media) {
    final model = MediaModel.of(context);

    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return PhotoMediaDialog(mediaModel: model, index: _index);
      },
    ));
  }
}
