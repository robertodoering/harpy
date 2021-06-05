import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

typedef OnOpenMediaOverlay = void Function(Widget child);

class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bloc = context.watch<TweetBloc>();

    final uncroppedImage = tweet.hasSingleImage &&
        mediaQuery.orientation == Orientation.portrait &&
        !app<MediaPreferences>().cropImage;

    Widget child;
    double? aspectRatio;

    if (tweet.hasImages) {
      if (tweet.hasSingleImage) {
        aspectRatio = tweet.images!.first.aspectRatio;
      }

      child = TweetImages(
        tweet,
        tweetBloc: bloc,
        uncroppedImage: uncroppedImage,
      );
    } else if (tweet.hasVideo) {
      aspectRatio = tweet.video!.validAspectRatio
          ? tweet.video!.aspectRatioDouble
          : 16 / 9;

      child = TweetVideo(tweet, tweetBloc: bloc);
    } else if (tweet.hasGif) {
      aspectRatio =
          tweet.gif!.validAspectRatio ? tweet.gif!.aspectRatioDouble : 16 / 9;

      child = TweetGif(tweet, tweetBloc: bloc);
    } else {
      child = const SizedBox();
    }

    return TweetMediaLayout(
      isImage: tweet.hasImages,
      aspectRatio: aspectRatio,
      uncroppedImage: uncroppedImage,
      child: child,
    );
  }
}
