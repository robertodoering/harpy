import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';

class MediaGallery extends StatelessWidget {
  const MediaGallery({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: Navigator.of(context).pop),
        Center(child: child),
      ],
    );
  }
}

void showGallery(BuildContext context, Widget child) {
  Navigator.of(context).push<void>(
    HeroDialogRoute(
      builder: (_) => MediaGallery(child: child),
    ),
  );
}
