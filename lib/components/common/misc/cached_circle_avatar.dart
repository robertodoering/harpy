import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Builds a [CircleAvatar] with a [CachedNetworkImage].
class CachedCircleAvatar extends StatelessWidget {
  const CachedCircleAvatar({
    @required this.imageUrl,
    this.backgroundColor = Colors.transparent,
    this.radius,
  });

  final String imageUrl;
  final Color backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: SizedBox.expand(
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imageUrl,
          ),
        ),
      ),
    );
  }
}
