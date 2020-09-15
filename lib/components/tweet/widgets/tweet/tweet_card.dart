import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/replies.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/tweet_card_content.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds a [Card] with the [TweetCardContent] that animates when scrolling
/// down with a [ListCardAnimation].
class TweetCard extends StatelessWidget {
  TweetCard(this.tweet) : super(key: ValueKey<int>(tweet.hashCode));

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    return ListCardAnimation(
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: Column(
          children: <Widget>[
            TweetCardContent(tweet),
            if (tweet.replies.isNotEmpty) TweetReplies(tweet),
          ],
        ),
      ),
    );
  }
}
