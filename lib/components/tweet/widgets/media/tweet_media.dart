import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Builds the media for the tweet.
class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    if (tweet.images?.isNotEmpty == true) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: TweetImages(tweet.images),
      );
    } else {
      return Container();
    }
  }
}
