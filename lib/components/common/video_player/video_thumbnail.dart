import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';

/// Builds the [thumbnail] as an image with a centered [icon] that changes to a
/// [CircularProgressIndicator] when [initializing] is `true`.
class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    @required this.thumbnail,
    @required this.icon,
    @required this.initializing,
    @required this.onTap,
  });

  final String thumbnail;

  final IconData icon;

  final bool initializing;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget child = initializing
        ? const SizedBox(
            width: kVideoPlayerCenterIconSize,
            height: kVideoPlayerCenterIconSize,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Icon(
            icon,
            color: Colors.white,
            size: kVideoPlayerCenterIconSize,
          );

    return Stack(
      children: <Widget>[
        if (thumbnail != null)
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: thumbnail,
            height: double.infinity,
            width: double.infinity,
          ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
            ),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
        GestureDetector(onTap: onTap),
      ],
    );
  }
}
