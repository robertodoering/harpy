import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/components/widgets/media/media_gif_player.dart';
import 'package:harpy/components/widgets/media/media_image.dart';
import 'package:harpy/components/widgets/media/media_video_player.dart';
import 'package:harpy/components/widgets/shared/custom_expansion_tile.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/media_model.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:provider/provider.dart';

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

    return ChangeNotifierProvider<MediaModel>(
      builder: (_) => mediaModel,
      child: CustomExpansionTile(
        initiallyExpanded: mediaModel.initiallyShown,
        onExpansionChanged: mediaModel.saveShowMediaState,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaModel.media
                    .any((media) => media.type == photo || media.type == video)
                ? 250.0 // todo: maybe default to a 16:9 size for videos
                // (9 / 16) * MediaQuery.of(context).size.width;
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
  static const double padding = 2;

  @override
  Widget build(BuildContext context) {
    final model = MediaModel.of(context);

    if (model.media.length == 1) {
      return Row(
        children: <Widget>[
          const _TweetMediaWidget(0),
        ],
      );
    } else if (model.media.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _TweetMediaWidget(0),
          const SizedBox(width: padding),
          const _TweetMediaWidget(1),
        ],
      );
    } else if (model.media.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _TweetMediaWidget(0),
          const SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                const _TweetMediaWidget(1),
                const SizedBox(height: padding),
                const _TweetMediaWidget(2),
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
                const _TweetMediaWidget(0),
                const SizedBox(height: padding),
                const _TweetMediaWidget(2),
              ],
            ),
          ),
          const SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                const _TweetMediaWidget(1),
                const SizedBox(height: padding),
                const _TweetMediaWidget(3),
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

/// Builds a [MediaImage], [MediaGifPlayer] or [MediaVideoPlayer] for images,
/// gifs and videos.
class _TweetMediaWidget extends StatelessWidget {
  const _TweetMediaWidget(this._index);

  final int _index;

  @override
  Widget build(BuildContext context) {
    final mediaModel = MediaModel.of(context);

    final TwitterMedia media = mediaModel.media[_index];

    Widget mediaWidget;

    if (media.type == photo) {
      mediaWidget = MediaImage(
        index: _index,
        mediaModel: mediaModel,
      );
    } else if (media.type == animatedGif) {
      mediaWidget = MediaGifPlayer(
        mediaModel: mediaModel,
      );
    } else if (media.type == video) {
      mediaWidget = MediaVideoPlayer(
        mediaModel: mediaModel,
      );
    }

    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Hero(
          tag: mediaModel.mediaHeroTag(_index),
          placeholderBuilder: (context, size, widget) => widget,
          child: mediaWidget ?? Container(),
        ),
      ),
    );
  }
}
