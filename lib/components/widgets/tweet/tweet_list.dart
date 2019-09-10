import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/load_more_list.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';

/// Builds a [ListView] for a list of tweets.
///
/// The tweets are built as [TweetTile]s.
///
/// [leading] will be built at the start of the list.
/// [placeHolder] will be built instead of [tweets] if [tweets] is empty.
/// [trailing] will be built at the end of the list.
class TweetList extends StatelessWidget {
  TweetList({
    @required List<Tweet> tweets,
    this.scrollController,
    this.onLoadMore,
    this.enableLoadMore = false,
    Widget leading,
    Widget placeHolder,
    Widget trailing,
  }) {
    if (leading != null) {
      _content.add(leading);
    }

    if (tweets.isEmpty) {
      if (placeHolder != null) {
        _content.add(placeHolder);
      }
    } else {
      _content.addAll(tweets);
    }

    if (trailing != null) {
      _content.add(trailing);
    }
  }

  /// The [ScrollController] for the [TweetList].
  final ScrollController scrollController;

  /// The full content of the list.
  final List<dynamic> _content = [];

  final OnLoadMore onLoadMore;

  final bool enableLoadMore;

  /// Builds an item in the list.
  ///
  /// If the item is a [Tweet] it will be built as a [TweetTile].
  Widget _itemBuilder(BuildContext context, int index) {
    final item = _content[index];

    return item is Tweet
        ? TweetTile(
            key: ValueKey<int>(item.id),
            tweet: item,
          )
        : item;
  }

  // todo: maybe make tweetlist stateful and override didUpdateWidget to animate
  //  the new list content

  @override
  Widget build(BuildContext context) {
    final childCount = _content.length;

    final childrenDelegate = CustomSliverChildBuilderDelegate(
      _itemBuilder,
      itemCount: childCount,
    );

    return LoadMoreList(
      onLoadMore: onLoadMore,
      enable: enableLoadMore,
      child: ListView.custom(
        controller: scrollController,
        padding: EdgeInsets.zero,
        childrenDelegate: childrenDelegate,
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
