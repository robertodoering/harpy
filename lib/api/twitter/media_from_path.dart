import 'package:harpy/api/api.dart';
import 'package:mime_type/mime_type.dart';

/// Uses [mime] to find the [MediaType] from a file path.
MediaType findMediaType(String path) {
  final String mimeType = mime(path);

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
