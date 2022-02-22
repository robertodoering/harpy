import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef TweetBuilder = Widget Function(TweetData tweet);

/// Signature for a function that is called at the end of layout in the list
/// builder.
typedef OnLayoutFinished = void Function(int firstIndex, int lastIndex);

/// Builds a [CustomScrollView] for the [tweets].
class TweetList extends ConsumerWidget {
  const TweetList(
    this.tweets, {
    this.controller,
    this.tweetBuilder = defaultTweetBuilder,
    this.onLayoutFinished,
    this.beginSlivers = const [],
    this.endSlivers = const [],
  });

  /// The list of tweets to be displayed in this list.
  final List<TweetData> tweets;
  final ScrollController? controller;
  final TweetBuilder tweetBuilder;
  final OnLayoutFinished? onLayoutFinished;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  static Widget defaultTweetBuilder(TweetData tweet) => TweetCard(tweet: tweet);

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isEven)
      return tweetBuilder(tweets[index ~/ 2]);
    else
      return verticalSpacer;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return CustomScrollView(
      controller: controller,
      cacheExtent: 0,
      slivers: [
        ...beginSlivers,
        SliverPadding(
          padding: display.edgeInsets,
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
