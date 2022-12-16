import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef GalleryEntryBuilder = MediaGalleryEntry? Function(int index);

class MediaGalleryEntry {
  const MediaGalleryEntry({
    required this.tweet,
    required this.delegates,
    required this.media,
    required this.builder,
  });

  final LegacyTweetData tweet;
  final TweetDelegates delegates;
  final MediaData media;
  final WidgetBuilder builder;
}

/// Shows multiple tweet media in a [HarpyPhotoGallery].
///
/// * Used by [TweetImages] to showcase all images for a tweet in one gallery.
/// * Used by [MediaTimeline] to show all media entries in a single gallery.
class MediaGallery extends ConsumerStatefulWidget {
  const MediaGallery({
    required this.builder,
    required this.itemCount,
    this.initialIndex = 0,
    this.actions = kDefaultOverlayActions,
  });

  final GalleryEntryBuilder builder;
  final int itemCount;
  final int initialIndex;
  final Set<MediaOverlayActions> actions;

  @override
  ConsumerState<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends ConsumerState<MediaGallery> {
  late int _index;

  @override
  void initState() {
    super.initState();

    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.builder(_index);

    if (entry == null) return const SizedBox();

    return MediaGalleryOverlay(
      tweet: entry.tweet,
      media: entry.media,
      delegates: entry.delegates,
      actions: widget.actions,
      child: HarpyPhotoGallery(
        initialIndex: widget.initialIndex,
        itemCount: widget.itemCount,
        // disallow zooming in on videos
        enableGestures: entry.media.type != MediaType.video,
        builder: (context, index) =>
            widget.builder(index)?.builder(context) ?? const SizedBox(),
        onPageChanged: (index) {
          setState(() => _index = index);
          ref
              .read(videoPlayerHandlerProvider)
              .act((notifier) => notifier.pause());
        },
      ),
    );
  }
}
