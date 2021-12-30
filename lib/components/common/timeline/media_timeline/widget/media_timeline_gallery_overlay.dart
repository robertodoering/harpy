import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a [HarpyMediaGallery] with a [MediaOverlay] to access the tweet
/// actions (like / retweet) and media actions (open externally, download,
/// share) in the gallery.
class MediaTimelineGalleryOverlay extends StatefulWidget {
  const MediaTimelineGalleryOverlay({
    required this.entries,
    required this.initialIndex,
    required this.videoPlayerModel,
  });

  final List<MediaTimelineEntry> entries;
  final int initialIndex;
  final HarpyVideoPlayerModel? videoPlayerModel;

  @override
  _MediaTimelineGalleryOverlayState createState() =>
      _MediaTimelineGalleryOverlayState();
}

class _MediaTimelineGalleryOverlayState
    extends State<MediaTimelineGalleryOverlay> {
  late int _index;
  late TweetData _tweet;
  late TweetBloc _bloc;

  String? get _mediaUrl {
    if (widget.entries[_index].isImage) {
      return widget.entries[_index].imageData!.bestUrl;
    } else if (widget.entries[_index].isVideo) {
      return widget.entries[_index].videoData!.bestUrl;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _index = widget.initialIndex;
    _tweet = widget.entries[widget.initialIndex].tweet;
    _bloc = TweetBloc(_tweet);
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  void _onPageChanged(int newIndex) {
    _index = newIndex;

    final newTweet = widget.entries[newIndex].tweet;

    if (mounted && newTweet.id != _tweet.id) {
      setState(() {
        _tweet = newTweet;
        _bloc.close();
        _bloc = TweetBloc(_tweet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MediaOverlay(
        enableImmersiveMode: false,
        onOpenExternally: () => defaultOnMediaOpenExternally(_mediaUrl),
        onDownload: () => defaultOnMediaDownload(
          downloadPathCubit: context.read(),
          type: _tweet.mediaType,
          url: _mediaUrl,
        ),
        onShare: () => defaultOnMediaShare(_mediaUrl),
        onShowTweet: () => app<HarpyNavigator>().pushTweetDetailScreen(
          tweet: _tweet,
        ),
        child: HarpyMediaGallery.builder(
          itemCount: widget.entries.length,
          initialIndex: widget.initialIndex,
          heroTagBuilder: (index) => widget.entries[index].isImage
              ? '$index-${widget.entries[index].media!.appropriateUrl}'
              : null,
          onPageChanged: _onPageChanged,
          builder: (_, index) => MediaTimelineGalleryWidget(
            entry: widget.entries[index],
            initialIndex: widget.initialIndex,
            index: index,
            videoPlayerModel: widget.videoPlayerModel,
          ),
        ),
      ),
    );
  }
}
