import 'dart:io';

import 'package:mime_type/mime_type.dart';

String getFileExtension(String path) {
  final index = path.lastIndexOf(".");

  if (index != -1) {
    return path.substring(index + 1);
  } else {
    return null;
  }
}

enum FileType {
  image,
  gif,
  video,
}

FileType getFileType(File file) {
  final String mimeType = mime(file.path);

  // unknown type
  if (mimeType == null) {
    return null;
  }

  if (mimeType.startsWith("video")) {
    return FileType.video;
  }

  if (mimeType == "image/gif") {
    return FileType.gif;
  }

  if (mimeType.startsWith("image")) {
    return FileType.image;
  }

  return null;
}
