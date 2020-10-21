import 'package:flutter/material.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_gif.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_images.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_video.dart';
import 'package:harpy/components/tweet/widgets/overlay/media_overlay.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

typedef OnOpenMediaOverlay = void Function(Widget child);

/// Builds the media for the tweet.
///
/// Images are limited to a 16 / 9 aspect ratio.
/// Videos and gifs will retain their aspect ratio when built.
class TweetMedia extends StatelessWidget {
  const TweetMedia(this.tweet);

  final TweetData tweet;

  void _openOverlay(TweetBloc bloc, Widget child) {
    app<HarpyNavigator>().pushRoute(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => MediaOverlay(
          tweet: tweet,
          tweetBloc: bloc,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxHeight = mediaQuery.size.height / 2;

    // todo: maybe don't constrain size of videos / gifs this way

    if (tweet.images?.isNotEmpty == true) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: TweetImages(
            tweet.images,
            onOpenMediaOverlay: (Widget child) => _openOverlay(bloc, child),
          ),
        ),
      );
    } else if (tweet.video != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: tweet.video.validAspectRatio
              ? tweet.video.aspectRatioDouble
              : 16 / 9,
          child: TweetVideo(tweet.video),
        ),
      );
    } else if (tweet.gif != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio:
              tweet.gif.validAspectRatio ? tweet.gif.aspectRatioDouble : 16 / 9,
          child: TweetGif(tweet.gif),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
