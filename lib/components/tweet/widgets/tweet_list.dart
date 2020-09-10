import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_tile.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds a [CustomScrollView] for the [tweets].
///
/// An optional list of [headerSlivers] are built before the [tweets].
class TweetList extends StatelessWidget {
  const TweetList(
    this.tweets, {
    this.headerSlivers = const <Widget>[],
    this.controller,
    this.enableScroll = true,
  });

  /// The list of tweets to be displayed in this list.
  final List<TweetData> tweets;

  /// Slivers built at the beginning of the [CustomScrollView].
  final List<Widget> headerSlivers;

  /// An optional scroll controller used by the [CustomScrollView].
  final ScrollController controller;

  /// Whether the tweet list should be scrollable.
  final bool enableScroll;

  Widget _itemBuilder(BuildContext context, int index) {
    final int itemIndex = index ~/ 2;

    if (index.isEven) {
      return TweetTile(tweets[itemIndex]);
    } else {
      return const SizedBox(height: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: enableScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      cacheExtent: 800,
      slivers: <Widget>[
        ...headerSlivers,
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              _itemBuilder,
              childCount: tweets.length * 2 - 1,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
      ],
    );
  }
}
