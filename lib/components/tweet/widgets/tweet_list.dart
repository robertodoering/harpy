import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

typedef TweetBuilder = Widget Function(LegacyTweetData tweet, int index);

/// Signature for a function that is called at the end of layout in the list
/// builder.
typedef OnLayoutFinished = void Function(int firstIndex, int lastIndex);

/// Builds a [CustomScrollView] for the [tweets].
class TweetList extends StatelessWidget {
  const TweetList(
    this.tweets, {
    this.controller,
    this.tweetBuilder = defaultTweetBuilder,
    this.onLayoutFinished,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    super.key,
  });

  final List<LegacyTweetData> tweets;
  final ScrollController? controller;
  final TweetBuilder tweetBuilder;
  final OnLayoutFinished? onLayoutFinished;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  static Widget defaultTweetBuilder(LegacyTweetData tweet, int index) =>
      TweetCard(
        tweet: tweet,
        index: index,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    return index.isEven
        ? tweetBuilder(tweets[index ~/ 2], index ~/ 2)
        : VerticalSpacer.normal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      controller: controller,
      cacheExtent: 0,
      slivers: [
        ...beginSlivers,
        SliverPadding(
          padding: theme.spacing.edgeInsets,
          sliver: SuperSliverList(
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
