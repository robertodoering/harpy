import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';

/// Builds a [ListView] for the [tweets].
///
/// The [tweets] are built as [TweetTile]s.
///
/// [leading] will be built at the start of the list.
/// [placeHolder] will be built instead of [tweets] if [tweets] is empty.
/// [trailing] will be built at the end of the list.
class TweetList extends StatelessWidget {
  TweetList({
    @required List<Tweet> tweets,
    this.scrollController,
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

  /// Calls [_itemBuilder] or [_separatorBuilder] depending on the current
  /// index.
  Widget _childrenBuilder(BuildContext context, int index) {
    final int itemIndex = index ~/ 2;

    return index.isEven ? _itemBuilder(itemIndex) : _separatorBuilder();
  }

  /// Builds the item in the list.
  ///
  /// If the item is a [Tweet] it will be built as a [TweetTile].
  Widget _itemBuilder(int index) {
    final item = _content[index];

    return item is Tweet
        ? TweetTile(
            tweet: item,
            content: TweetTileContent(),
          )
        : item;
  }

  Widget _separatorBuilder() => const Divider(height: 0);

  @override
  Widget build(BuildContext context) {
    final childCount = _content.length * 2 - 1;

    final childrenDelegate = CustomSliverChildBuilderDelegate(
      _childrenBuilder,
      itemCount: childCount,
    );

    return ListView.custom(
      controller: scrollController,
      padding: EdgeInsets.zero,
      childrenDelegate: childrenDelegate,
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
