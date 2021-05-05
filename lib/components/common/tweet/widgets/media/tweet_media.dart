import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

typedef OnOpenMediaOverlay = void Function(Widget child);

class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData? tweet;

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);

    Widget child;
    double? aspectRatio;

    if (tweet!.hasImages) {
      child = TweetImages(
        tweet,
        tweetBloc: bloc,
      );
    } else if (tweet!.hasVideo) {
      aspectRatio = tweet!.video!.validAspectRatio
          ? tweet!.video!.aspectRatioDouble
          : 16 / 9;

      child = TweetVideo(
        tweet,
        tweetBloc: bloc,
      );
    } else if (tweet!.hasGif) {
      aspectRatio =
          tweet!.gif!.validAspectRatio ? tweet!.gif!.aspectRatioDouble : 16 / 9;

      child = TweetGif(
        tweet,
        tweetBloc: bloc,
      );
    } else {
      child = const SizedBox();
    }

    return TweetMediaLayout(
      isImage: tweet!.images?.isNotEmpty == true,
      videoAspectRatio: aspectRatio,
      child: child,
    );
  }
}
