import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class MediaGallery extends ConsumerStatefulWidget {
  const MediaGallery({
    required this.provider,
    required this.delegates,
    required this.builder,
    required this.itemCount,
    this.initialIndex = 0,
  });

  final StateNotifierProvider<TweetNotifier, TweetData> provider;
  final TweetDelegates delegates;
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int initialIndex;

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
    final tweet = ref.watch(widget.provider);

    return MediaGalleryOverlay(
      provider: widget.provider,
      media: tweet.media[_index],
      delegates: widget.delegates,
      child: HarpyImageGallery(
        initialIndex: widget.initialIndex,
        itemCount: widget.itemCount,
        builder: widget.builder,
        onPageChanged: (index) => setState(() => _index = index),
      ),
    );
  }
}
