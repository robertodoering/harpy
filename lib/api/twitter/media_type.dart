import 'package:mime_type/mime_type.dart';

/// The [MediaType] as it is returned in from twitter.
const String kMediaPhoto = 'photo';
const String kMediaVideo = 'video';
const String kMediaGif = 'animated_gif';

/// The type of media that can be attached to a tweet.
enum MediaType {
  image,
  gif,
  video,
}

extension MediaTypeExtension on MediaType {
  /// The human readable name of the type.
  String get name {
    switch (this) {
      case MediaType.gif:
        return 'gif';
      case MediaType.video:
        return 'video';
      case MediaType.image:
        return 'image';
    }
  }
}

/// Uses [mime] to find the [MediaType] from a file path.
MediaType? findMediaType(String? path) {
  final mimeType = mime(path);

  if (mimeType == null) {
    return null;
  } else if (mimeType.startsWith('video')) {
    return MediaType.video;
  } else if (mimeType == 'image/gif') {
    return MediaType.gif;
  } else if (mimeType.startsWith('image')) {
    return MediaType.image;
  } else {
    return null;
  }
}
