import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_gif.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_video.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Builds the media for the tweet.
///
/// Images are limited to a 16 / 9 aspect ratio.
/// Videos and gifs will retain their aspect ratio when built.
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
    } else if (tweet.gif != null) {
      return AspectRatio(
        aspectRatio:
            tweet.gif.validAspectRatio ? tweet.gif.aspectRatioDouble : 16 / 9,
        child: TweetGif(tweet.gif),
      );
    } else {
      return const SizedBox();
    }
  }
}
