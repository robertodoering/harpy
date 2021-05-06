import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a [CircleAvatar] with a [HarpyImage].
class HarpyCircleAvatar extends StatelessWidget {
  const HarpyCircleAvatar({
    required this.imageUrl,
    this.backgroundColor = Colors.transparent,
    this.radius,
    this.heroTag,
  });

  final String imageUrl;
  final Color backgroundColor;
  final double? radius;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget image = HarpyImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
    );

    if (heroTag != null) {
      image = Hero(
        tag: heroTag!,
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
