import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef TweetBuilder = Widget Function(TweetData tweet, int index);

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
    this.endSlivers = const [SliverBottomPadding()],
    super.key,
  });

  final List<TweetData> tweets;
  final ScrollController? controller;
  final TweetBuilder tweetBuilder;
  final OnLayoutFinished? onLayoutFinished;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  static Widget defaultTweetBuilder(TweetData tweet, int index) => TweetCard(
        tweet: tweet,
        index: index,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    return index.isEven
        ? tweetBuilder(tweets[index ~/ 2], index ~/ 2)
        : verticalSpacer;
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
    super.builder, {
    this.onLayoutFinished,
    super.childCount,
  }) : super(
          addAutomaticKeepAlives: false,
        );

  final OnLayoutFinished? onLayoutFinished;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    onLayoutFinished?.call(firstIndex, lastIndex);
  }
}
