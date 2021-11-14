import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

typedef TweetBuilder = Widget Function(TweetData tweet);

/// Signature for a function that is called at the end of layout in the list
/// builder.
typedef OnLayoutFinished = void Function(int firstIndex, int lastIndex);

/// Builds a [CustomScrollView] for the [tweets].
///
/// An optional list of [beginSlivers] are built before the [tweets] and
/// [endSlivers] are built after the [tweets].
class TweetList extends StatelessWidget {
  const TweetList(
    this.tweets, {
    this.controller,
    this.tweetBuilder = defaultTweetBuilder,
    this.onLayoutFinished,
    this.beginSlivers = const [],
    this.endSlivers = const [],
    this.enableScroll = true,
    Key? key,
  }) : super(key: key);

  /// The list of tweets to be displayed in this list.
  final List<TweetData> tweets;

  final ScrollController? controller;

  final TweetBuilder tweetBuilder;

  final OnLayoutFinished? onLayoutFinished;

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
      return verticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return CustomScrollView(
      controller: controller,
      physics: enableScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      cacheExtent: 0,
      slivers: [
        ...beginSlivers,
        SliverPadding(
          padding: config.edgeInsets,
          sliver: SliverList(
            delegate: _TweetListBuilderDelegate(
              _itemBuilder,
              onLayoutFinished: onLayoutFinished,
              childCount: tweets.length * 2 - 1,
            ),
          ),
        ),
        ...endSlivers,
      ],
    );
  }
}

class _TweetListBuilderDelegate extends SliverChildBuilderDelegate {
  _TweetListBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    this.onLayoutFinished,
    int? childCount,
  }) : super(
          builder,
          childCount: childCount,
          addAutomaticKeepAlives: false,
        );

  final OnLayoutFinished? onLayoutFinished;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    onLayoutFinished?.call(firstIndex, lastIndex);
  }
}
