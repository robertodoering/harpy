import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a [FadeInImage] for a transparent placeholder and an error widget
/// builder.
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

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      width: double.infinity,
      height: double.infinity,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      image: imageUrl,
      imageErrorBuilder: _buildErrorWidget,
      placeholder: kTransparentImage,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
