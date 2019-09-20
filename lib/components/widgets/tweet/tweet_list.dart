import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/load_more_list.dart';
import 'package:harpy/components/widgets/shared/scroll_direction_listener.dart';
import 'package:harpy/components/widgets/shared/scroll_to_start.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';

/// Builds a [ListView] for a list of tweets.
///
/// The tweets are built as [TweetTile]s.
///
/// [leading] will be built at the start of the list.
/// [placeHolder] will be built instead of [tweets] if [tweets] is empty.
class TweetList extends StatelessWidget {
  TweetList({
    @required List<Tweet> tweets,
    this.scrollController,
    this.onLoadMore,
    this.enableLoadMore = false,
    Widget leading,
    Widget placeHolder,
  }) {
    if (leading != null) {
      _content..add(leading)..add(const Divider(height: 0));
    }

    if (tweets.isEmpty) {
      if (placeHolder != null) {
        _content.add(placeHolder);
      }
    } else {
      _content.addAll(tweets);
    }
  }

  /// The [ScrollController] for the [TweetList].
  final ScrollController scrollController;

  /// The full content of the list.
  ///
  /// Can be of type [Widget] or [Tweet].
  final List<dynamic> _content = [];

  /// Used by the [LoadMoreList] to load more tweets when reaching the end of
  /// the list.
  final OnLoadMore onLoadMore;

  /// Whether or not more tweets should be requested when reaching the end of
  /// the list.
  final bool enableLoadMore;

  /// Builds an item in the list.
  ///
  /// If the item is a [Tweet] it will be built as a [TweetTile].
  Widget _itemBuilder(BuildContext context, int index) {
    final item = _content[index];

    if (item is Tweet) {
      return TweetTile(
        key: ValueKey<int>(item.id),
        tweet: item,
      );
    } else {
      return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    final childCount = _content.length;

    final childrenDelegate = CustomSliverChildBuilderDelegate(
      _itemBuilder,
      itemCount: childCount,
    );

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreList(
          onLoadMore: onLoadMore,
          enable: enableLoadMore,
          loadingText: "Loading more Tweets...",
          child: ListView.custom(
            controller: scrollController,
            padding: EdgeInsets.zero,
            childrenDelegate: childrenDelegate,
          ),
        ),
      ),
    );
  }
}

/// Called at the end of layout to indicate that layout is now complete.
typedef OnLayoutFinish = void Function(int firstIndex, int lastIndex);

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  const CustomSliverChildBuilderDelegate(
    IndexedWidgetBuilder builder, {
    @required int itemCount,
    this.onLayoutFinish,
  }) : super(
          builder,
          childCount: itemCount,
          addAutomaticKeepAlives: true,
        );

  final OnLayoutFinish onLayoutFinish;

  // todo: override estimated size algorithm for a better scrollbar

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    if (onLayoutFinish != null) {
      onLayoutFinish(firstIndex, lastIndex);
    }
  }
}
