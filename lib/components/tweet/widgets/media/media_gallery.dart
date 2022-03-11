import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:photo_view/photo_view.dart';

typedef GalleryEntryBuilder = MediaGalleryEntry Function(int index);

class MediaGalleryEntry {
  const MediaGalleryEntry({
    required this.provider,
    required this.delegates,
    required this.media,
    required this.builder,
  });

  final StateNotifierProvider<TweetNotifier, TweetData> provider;
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
    this.onPageChanged,
  });

  final GalleryEntryBuilder builder;
  final int itemCount;
  final int initialIndex;
  final IndexedVoidCallback? onPageChanged;

  @override
  _MediaGalleryState createState() => _MediaGalleryState();
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

    return MediaGalleryOverlay(
      provider: entry.provider,
      media: entry.media,
      delegates: entry.delegates,
      child: HarpyPhotoGallery(
        initialIndex: widget.initialIndex,
        itemCount: widget.itemCount,
        // disallow zooming in on videos
        maxScale: entry.media.type == MediaType.video
            ? PhotoViewComputedScale.covered
            : null,
        builder: (context, index) => widget.builder(index).builder(context),
        onPageChanged: (index) {
          widget.onPageChanged?.call(index);
          setState(() => _index = index);
        },
      ),
    );
  }
}
