import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_video.dart';
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
    } else if (tweet.video != null) {
      return AspectRatio(
        aspectRatio: tweet.video.validAspectRatio
            ? tweet.video.aspectRatioDouble
            : 16 / 9,
        child: TweetVideo(tweet.video),
      );
    } else {
      return const SizedBox();
    }
  }
}
