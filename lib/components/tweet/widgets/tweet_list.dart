import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/load_more_list.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/tweet/widgets/tweet_tile.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Builds a list for the [tweets].
class TweetList extends StatelessWidget {
  const TweetList(
    this.tweets, {
    @required this.onRefresh,
    @required this.onLoadMore,
    @required this.enableLoadMore,
  });

  /// The list of tweets to be displayed in this list.
  final List<TweetData> tweets;

  /// The callback for a [RefreshIndicator] built above the list.
  final RefreshCallback onRefresh;

  /// The callback for loading more data.
  final OnLoadMore onLoadMore;

  /// Whether to enable the [LoadMoreList] to load more data.
  final bool enableLoadMore;

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: LoadMoreList(
            onLoadMore: onLoadMore,
            enable: enableLoadMore,
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) =>
                  TweetTile(tweets[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
            ),
          ),
        ),
      ),
    );
  }
}
