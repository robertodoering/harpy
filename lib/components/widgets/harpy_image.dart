import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:rby/rby.dart';
import 'package:shimmer/shimmer.dart';

/// Builds a network [Image] with a shimmer loading animation that fades into
/// the loaded image.
class HarpyImage extends StatelessWidget {
  const HarpyImage({
    required String this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.catchGesturesOnError = true,
  }) : imageProvider = null;

  const HarpyImage.fromImageProvider({
    required ImageProvider this.imageProvider,
    this.fit,
    this.width,
    this.height,
    this.catchGesturesOnError = true,
  }) : imageUrl = null;

  final String? imageUrl;
  final ImageProvider? imageProvider;
  final BoxFit? fit;
  final double? width;
  final double? height;

  /// Whether on tap gestures should be caught in the error builder.
  final bool catchGesturesOnError;

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      // empty on tap to prevent tap gestures on error widget
      onTap: catchGesturesOnError ? () {} : null,
      child: Container(
        color: theme.cardColor,
        width: width,
        height: height,
        child: FractionallySizedBox(
          widthFactor: .5,
          heightFactor: .5,
          child: FittedBox(
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _frameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded) return child;

    final theme = Theme.of(context);

    return RbyAnimatedSwitcher(
      child: frame == null
          ? GestureDetector(
              // empty on tap to prevent tap gestures on loading shimmer
              onTap: () {},
              child: Shimmer(
                gradient: LinearGradient(
                  colors: [
                    theme.cardTheme.color!.withOpacity(.3),
                    theme.cardTheme.color!.withOpacity(.3),
                    theme.colorScheme.secondary,
                    theme.cardTheme.color!.withOpacity(.3),
                    theme.cardTheme.color!.withOpacity(.3),
                  ],
                ),
                child: SizedBox.expand(
                  child: ColoredBox(color: theme.cardTheme.color!),
                ),
              ),
            )
          : child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image(
        // fallback to NetworkImage in tests because we can't use mocked http
        // overrides for `NetworkImageWithRetry`
        image: imageProvider ??
            (isTest
                ? NetworkImage(imageUrl!)
                : NetworkImageWithRetry(imageUrl!)) as ImageProvider,
        errorBuilder: _errorBuilder,
        frameBuilder: _frameBuilder,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
