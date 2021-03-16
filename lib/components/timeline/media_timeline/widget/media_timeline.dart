import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:harpy/components/common/image_gallery/harpy_media_gallery.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/media_timeline/model/media_timeline_model.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:provider/provider.dart';

import 'media_timeline_gallery_overlay.dart';
import 'media_timeline_media_widget.dart';

/// Builds the list of tweet media widgets for a [MediaTimelineModel].
///
/// Tapping a media will open the [HarpyMediaGallery].
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
    return MediaTimelineMediaWidget(
      entry: entries[index],
      index: index,
      onImageTap: () => _showGallery(
        context: context,
        entries: entries,
        initialIndex: index,
      ),
      onVideoTap: (HarpyVideoPlayerModel videoPlayerModel) => _showGallery(
        context: context,
        entries: entries,
        initialIndex: index,
        videoPlayerModel: videoPlayerModel,
      ),
      buildCompactOverlay: _buildTiled,
    );
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
    final UserTimelineBloc bloc = context.watch<UserTimelineBloc>();
    final UserTimelineState state = bloc.state;
    final MediaTimelineModel model = context.watch<MediaTimelineModel>();
    final List<MediaTimelineEntry> entries = model.value;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          model.hasEntries ? _buildFloatingActionButton() : null,
      body: LoadMoreListener(
        listen: state.enableRequestOlder,
        onLoadMore: () async {
          bloc.add(const RequestOlderUserTimeline());
          await bloc.requestOlderCompleter.future;
        },
        child: CustomScrollView(
          key: const PageStorageKey<String>('user_media_timeline'),
          slivers: <Widget>[
            if (state.showInitialLoading)
              const SliverFillLoadingIndicator()
            else if (model.hasEntries) ...<Widget>[
              SliverPadding(
                padding: DefaultEdgeInsets.all(),
                // need to rebuild the full list when switching tiling mode,
                // otherwise the scroll controller gets confused
                sliver: _buildTiled
                    ? _buildTiledList(entries)
                    : _buildList(entries),
              ),
              if (state.showLoadingOlder) const SliverBoxLoadingIndicator(),
            ] else
              const SliverFillLoadingError(
                message: Text('no media found'),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show the [HarpyMediaGallery] for the media timeline [entries].
///
/// The [videoPlayerModel] is used when tapping on a gif or video to build
/// the video or gif with the video player model.
void _showGallery({
  @required BuildContext context,
  @required List<MediaTimelineEntry> entries,
  @required int initialIndex,
  HarpyVideoPlayerModel videoPlayerModel,
}) {
  Navigator.of(context).push<void>(
    HeroDialogRoute<void>(
      builder: (_) => MediaTimelineGalleryOverlay(
        entries: entries,
        initialIndex: initialIndex,
        videoPlayerModel: videoPlayerModel,
      ),
    ),
  );
}
