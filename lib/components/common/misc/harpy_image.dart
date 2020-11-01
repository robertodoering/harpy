import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Wraps a [CachedNetworkImage] with an error builder.
class HarpyImage extends StatelessWidget {
  const HarpyImage({
    @required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double height;

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
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
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorWidget: _buildErrorWidget,
    );
  }
}
