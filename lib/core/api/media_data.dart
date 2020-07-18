import 'package:dart_twitter_api/twitter_api.dart';

class ImageData {
  ImageData.fromMedia(Media media) {
    baseUrl = media.mediaUrlHttps;
  }

  /// The base url for the image.
  String baseUrl;

  String get thumb => '$baseUrl?name=thumb';
  String get small => '$baseUrl?name=small';
  String get medium => '$baseUrl?name=medium';
  String get large => '$baseUrl?name=large';
}

class VideoData {
  VideoData.fromMedia(Media media) {
    // removes variants that does not have a bitrate (content type:
    // 'application/x-mpegURL') and then sorts them by the bitrate ascending
    // (lowest quality first)
    variants = media.videoInfo.variants
        .where((Variant variant) => variant.bitrate != null)
        .toList()
          ..sort((Variant a, Variant b) => a.bitrate.compareTo(b.bitrate));
  }

  /// The aspect ratio of the video.
  List<int> aspectRatio;

  /// The video variants sorted by their quality (lowest quality first).
  List<Variant> variants;
}
