import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/replies.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/tweet_card_content.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_remember_visibility.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds a [Card] with the [TweetCardContent] that animates when scrolling
/// down with a [ListCardAnimation].
class TweetCard extends StatelessWidget {
  TweetCard(
    this.tweet, {
    this.color,
    this.depth = 0,
  }) : super(key: ValueKey<int>(tweet.hashCode));

  final TweetData tweet;
  final Color color;
  final int depth;

  @override
  Widget build(BuildContext context) {
    // todo: disable saving visibility when not in home timeline
    return TweetRememberVisibility(
      key: Key('${tweet.hashCode}_visibility'),
      tweet: tweet,
      child: ListCardAnimation(
        key: Key('${tweet.hashCode}_animation'),
        child: Card(
          color: color,
          child: Column(
            children: <Widget>[
              TweetCardContent(tweet),
              if (tweet.replies.isNotEmpty) TweetReplies(tweet, depth: depth),
            ],
          ),
        ),
      ),
    );
  }
}
