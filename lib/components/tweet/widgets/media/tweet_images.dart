import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class TweetImages extends ConsumerWidget {
  const TweetImages({
    required this.tweet,
    required this.delegates,
    this.tweetIndex,
    this.onImageLongPress,
  });

  final LegacyTweetData tweet;
  final TweetDelegates delegates;
  final int? tweetIndex;
  final IndexedVoidCallback? onImageLongPress;

  void _onImageTap(
    BuildContext context, {
    required int index,
    required LegacyTweetData tweet,
  }) {
    final theme = Theme.of(context);

    Navigator.of(context).push<void>(
      HeroDialogRoute(
        builder: (_) => MediaGallery(
          initialIndex: index,
          itemCount: tweet.media.length,
          builder: (index) => MediaGalleryEntry(
            tweet: tweet,
            delegates: delegates,
            media: tweet.media[index],
            builder: (_) => TweetGalleryImage(
              media: tweet.media[index],
              heroTag: 'tweet${mediaHeroTag(
                context,
                tweet: tweet,
                media: tweet.media[index],
                index: tweetIndex,
              )}',
              borderRadius: _borderRadiusForImage(
                theme.shape.radius,
                index,
                tweet.media.length,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    return TweetImagesLayout(
      onImageTap: (index) => _onImageTap(
        context,
        index: index,
        tweet: tweet,
      ),
      onImageLongPress: onImageLongPress,
      children: [
        for (final image in tweet.media)
          Hero(
            tag: 'tweet${mediaHeroTag(
              context,
              tweet: tweet,
              media: image,
              index: tweetIndex,
            )}',
            child: HarpyImage(
              imageUrl: image.appropriateUrl(mediaPreferences, connectivity),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
      ],
    );
  }
}

class TweetGalleryImage extends ConsumerWidget {
  const TweetGalleryImage({
    required this.media,
    required this.heroTag,
    required this.borderRadius,
  });

  final MediaData media;
  final Object heroTag;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    return AspectRatio(
      aspectRatio: media.aspectRatioDouble,
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: (
          _,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) =>
            _flightShuttleBuilder(
          borderRadius,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ),
        child: HarpyImage(
          imageUrl: media.appropriateUrl(mediaPreferences, connectivity),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

Widget _flightShuttleBuilder(
  BorderRadius beginRadius,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final hero = flightDirection == HeroFlightDirection.push
      ? fromHeroContext.widget as Hero
      : toHeroContext.widget as Hero;

  final tween = BorderRadiusTween(
    begin: beginRadius,
    end: BorderRadius.zero,
  );

  return AnimatedBuilder(
    animation: animation,
    builder: (_, __) => ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: tween.evaluate(animation)!,
      child: hero.child,
    ),
  );
}

BorderRadius _borderRadiusForImage(Radius radius, int index, int count) {
  switch (count) {
    case 1:
      return BorderRadius.all(radius);
    case 2:
      return BorderRadius.only(
        topLeft: index == 0 ? radius : Radius.zero,
        bottomLeft: index == 0 ? radius : Radius.zero,
        topRight: index == 1 ? radius : Radius.zero,
        bottomRight: index == 1 ? radius : Radius.zero,
      );
    case 3:
      return BorderRadius.only(
        topLeft: index == 0 ? radius : Radius.zero,
        bottomLeft: index == 0 ? radius : Radius.zero,
        topRight: index == 1 ? radius : Radius.zero,
        bottomRight: index == 2 ? radius : Radius.zero,
      );
    case 4:
      return BorderRadius.only(
        topLeft: index == 0 ? radius : Radius.zero,
        bottomLeft: index == 2 ? radius : Radius.zero,
        topRight: index == 1 ? radius : Radius.zero,
        bottomRight: index == 3 ? radius : Radius.zero,
      );
    default:
      return BorderRadius.zero;
  }
}
