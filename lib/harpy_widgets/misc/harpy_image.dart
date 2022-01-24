import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:shimmer/shimmer.dart';

/// Builds a network [Image] with a shimmer loading animation that fades into
/// the loaded image.
class HarpyImage extends StatelessWidget {
  const HarpyImage({
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: theme.cardColor,
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

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      child: loadingProgress == null
          ? child
          : Shimmer(
              gradient: LinearGradient(
                colors: [
                  theme.cardTheme.color!.withOpacity(.3),
                  theme.cardTheme.color!.withOpacity(.3),
                  theme.colorScheme.secondary,
                  theme.cardTheme.color!.withOpacity(.3),
                  theme.cardTheme.color!.withOpacity(.3),
                ],
              ),
              child: Container(color: theme.cardTheme.color),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      errorBuilder: _errorBuilder,
      // remove loading builder in golden tests
      loadingBuilder: isTest ? null : _loadingBuilder,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
