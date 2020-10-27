import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_gif.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_video.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

typedef OnOpenMediaOverlay = void Function(Widget child);

/// Builds the media for the tweet.
///
/// Images are limited to a 16 / 9 aspect ratio.
/// Videos and gifs will retain their aspect ratio when built.
class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData tweet;

  Widget _constrainVideoHeight({
    @required double maxHeight,
    @required double aspectRatio,
    @required Widget child,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double constraintsAspectRatio = constraints.biggest.aspectRatio;

          if (aspectRatio > constraintsAspectRatio) {
            // video does not take up the constrained height
            return AspectRatio(
              aspectRatio: aspectRatio,
              child: child,
            );
          } else {
            // video takes up all of the constrained height and overflows
            // the width of the child gets limited to a 16:9 aspect ratio
            return AspectRatio(
              aspectRatio: min(constraintsAspectRatio, 16 / 9),
              child: child,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxHeight = mediaQuery.size.height / 2;

    Widget child;

    if (tweet.images?.isNotEmpty == true) {
      child = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: TweetImages(
            tweet,
            tweetBloc: bloc,
          ),
        ),
      );
    } else if (tweet.video != null) {
      final double videoAspectRatio =
          tweet.video.validAspectRatio ? tweet.video.aspectRatioDouble : 16 / 9;

      child = _constrainVideoHeight(
        maxHeight: maxHeight,
        aspectRatio: videoAspectRatio,
        child: TweetVideo(tweet.video),
      );
    } else if (tweet.gif != null) {
      final double gifAspectRatio =
          tweet.gif.validAspectRatio ? tweet.gif.aspectRatioDouble : 16 / 9;

      child = _constrainVideoHeight(
        maxHeight: maxHeight,
        aspectRatio: gifAspectRatio,
        child: TweetGif(tweet.gif),
      );
    } else {
      child = const SizedBox();
    }

    return child;
  }
}
