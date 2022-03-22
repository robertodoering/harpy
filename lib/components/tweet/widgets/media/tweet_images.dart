import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TweetImages extends ConsumerWidget {
  const TweetImages({
    required this.provider,
    required this.delegates,
    this.onImageLongPress,
  });

  final AutoDisposeStateNotifierProvider<TweetNotifier, TweetData> provider;
  final TweetDelegates delegates;
  final IndexedVoidCallback? onImageLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final tweet = ref.watch(provider);

    return TweetImagesLayout(
      onImageTap: (index) => Navigator.of(context).push<void>(
        HeroDialogRoute(
          builder: (_) => MediaGallery(
            initialIndex: index,
            itemCount: tweet.media.length,
            builder: (index) => MediaGalleryEntry(
              provider: provider,
              delegates: delegates,
              media: tweet.media[index],
              builder: (_) => TweetGalleryImage(
                media: tweet.media[index],
                heroTag: 'tweet${mediaHeroTag(
                  context,
                  tweet: tweet,
                  media: tweet.media[index],
                )}',
                borderRadius: _borderRadiusForImage(
                  harpyTheme.radius,
                  index,
                  tweet.media.length,
                ),
              ),
            ),
          ),
        ),
      ),
      onImageLongPress: onImageLongPress,
      children: [
        for (final image in tweet.media)
          Hero(
            tag: 'tweet${mediaHeroTag(
              context,
              tweet: tweet,
              media: image,
            )}',
            placeholderBuilder: (_, __, child) => child,
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
      borderRadius: tween.evaluate(animation),
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
