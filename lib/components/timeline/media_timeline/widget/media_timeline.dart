import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/media_timeline/model/media_timeline_model.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:provider/provider.dart';

class MediaTimeline extends StatefulWidget {
  const MediaTimeline();

  @override
  _MediaTimelineState createState() => _MediaTimelineState();
}

class _MediaTimelineState extends State<MediaTimeline> {
  bool _buildTiled = true;

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => setState(() {
        _buildTiled = !_buildTiled;
      }),
      child: Icon(
        _buildTiled
            ? CupertinoIcons.square_split_1x2
            : CupertinoIcons.square_split_2x2,
      ),
    );
  }

  Widget _itemBuilder(List<MediaTimelineEntry> entries, int index) {
    final MediaTimelineEntry entry = entries[index];

    // todo: build media widgets

    if (entry.isImage) {
      return ClipRRect(
        borderRadius: kDefaultBorderRadius,
        child: AspectRatio(
          // switch between 16 / 9 and 8 / 9 (twice as tall as 16 / 9)
          aspectRatio: index.isEven ? 8 / 9 : 16 / 9,
          child: HarpyImage(
            imageUrl: entry.imageData.appropriateUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: kDefaultBorderRadius,
        child: AspectRatio(
          aspectRatio: entry.videoData.aspectRatioDouble,
          child: Center(child: Text('${entry.media.runtimeType}')),
        ),
      );
    }
  }

  Widget _buildTiledList(List<MediaTimelineEntry> entries) {
    return SliverStaggeredGrid.countBuilder(
      key: const Key('media_timeline_tiled_list'),
      itemCount: entries.length,
      crossAxisCount: 2,
      mainAxisSpacing: defaultSmallPaddingValue,
      crossAxisSpacing: defaultSmallPaddingValue,
      staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
      itemBuilder: (_, int index) => _itemBuilder(entries, index),
    );
  }

  Widget _buildList(List<MediaTimelineEntry> entries) {
    return SliverStaggeredGrid.countBuilder(
      key: const Key('media_timeline_list'),
      itemCount: entries.length,
      crossAxisCount: 2,
      mainAxisSpacing: defaultSmallPaddingValue,
      crossAxisSpacing: defaultSmallPaddingValue,
      staggeredTileBuilder: (_) => const StaggeredTile.fit(2),
      itemBuilder: (_, int index) => _itemBuilder(entries, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MediaTimelineModel model = context.watch<MediaTimelineModel>();
    final List<MediaTimelineEntry> entries = model.value;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _buildFloatingActionButton(),
      body: CustomScrollView(
        key: const PageStorageKey<String>('user_media_timeline'),
        slivers: <Widget>[
          SliverPadding(
            padding: DefaultEdgeInsets.all(),
            sliver:
                // need to rebuild the full list when switching tiling mode,
                // otherwise the scroll controller gets confused
                _buildTiled ? _buildTiledList(entries) : _buildList(entries),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
