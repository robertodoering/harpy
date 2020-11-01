import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';

/// Builds a [CircleAvatar] with a [HarpyImage].
class CachedCircleAvatar extends StatelessWidget {
  const CachedCircleAvatar({
    @required this.imageUrl,
    this.backgroundColor = Colors.transparent,
    this.radius,
    this.heroTag,
  });

  final String imageUrl;
  final Color backgroundColor;
  final double radius;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    Widget image = HarpyImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
    );

    if (heroTag != null) {
      image = Hero(
        tag: heroTag,
        child: image,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: SizedBox.expand(
        child: ClipOval(
          child: image,
        ),
      ),
    );
  }
}
