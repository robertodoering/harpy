import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_gif.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media_layout.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_video.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

typedef OnOpenMediaOverlay = void Function(Widget child);

class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);

    Widget child;
    double aspectRatio;

    if (tweet.images?.isNotEmpty == true) {
      child = TweetImages(
        tweet,
        tweetBloc: bloc,
      );
    } else if (tweet.video != null) {
      aspectRatio =
          tweet.video.validAspectRatio ? tweet.video.aspectRatioDouble : 16 / 9;

      child = TweetVideo(
        tweet,
        tweetBloc: bloc,
      );
    } else if (tweet.gif != null) {
      aspectRatio =
          tweet.gif.validAspectRatio ? tweet.gif.aspectRatioDouble : 16 / 9;

      child = TweetGif(
        tweet,
        tweetBloc: bloc,
      );
    } else {
      child = const SizedBox();
    }

    return TweetMediaLayout(
      isImage: tweet.images?.isNotEmpty == true,
      videoAspectRatio: aspectRatio,
      child: child,
    );
  }
}
