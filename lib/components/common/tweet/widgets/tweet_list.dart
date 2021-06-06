import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

typedef TweetBuilder = Widget Function(TweetData tweet);

/// Builds a [CustomScrollView] for the [tweets].
///
/// An optional list of [beginSlivers] are built before the [tweets] and
/// [endSlivers] are built after the [tweets].
class TweetList extends StatelessWidget {
  const TweetList(
    this.tweets, {
    this.controller,
    this.tweetBuilder = defaultTweetBuilder,
    this.beginSlivers = const <Widget>[],
    this.endSlivers = const <Widget>[],
    this.enableScroll = true,
    Key? key,
  }) : super(key: key);

  /// The list of tweets to be displayed in this list.
  final List<TweetData> tweets;

  final ScrollController? controller;

  final TweetBuilder tweetBuilder;

  /// Slivers built at the beginning of the [CustomScrollView].
  final List<Widget> beginSlivers;

  /// Slivers built at the end of the [CustomScrollView].
  final List<Widget> endSlivers;

  /// Whether the tweet list should be scrollable.
  final bool enableScroll;

  static Widget defaultTweetBuilder(TweetData tweet) {
    return TweetCard(tweet);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isEven) {
      return tweetBuilder(tweets[index ~/ 2]);
    } else {
      return AnimatedContainer(
        duration: kShortAnimationDuration,
        height: defaultPaddingValue,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: enableScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      cacheExtent: 0,
      slivers: <Widget>[
        ...beginSlivers,
        SliverPadding(
          padding: DefaultEdgeInsets.all(),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              _itemBuilder,
              childCount: tweets.length * 2 - 1,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
        ...endSlivers,
      ],
    );
  }
}
