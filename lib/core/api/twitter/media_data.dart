import 'package:dart_twitter_api/twitter_api.dart';

/// The image data for a [TweetData].
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

/// The video (and animated gif) data for a [TweetData].
class VideoData {
  VideoData.fromMedia(Media media) {
    aspectRatio = media.videoInfo.aspectRatio;

    // removes variants that does not have a bitrate (content type:
    // 'application/x-mpegURL') and then sorts them by the bitrate ascending
    // (lowest quality first)
    variants = media.videoInfo.variants
        .where((Variant variant) => variant.bitrate != null)
        .toList()
          ..sort((Variant a, Variant b) => a.bitrate.compareTo(b.bitrate));

    thumbnailUrl = media.mediaUrlHttps;
  }

  /// The aspect ratio of the video.
  List<int> aspectRatio;

  /// The video variants sorted by their quality (lowest quality first).
  List<Variant> variants;

  /// The url for a thumbnail image of the video.
  String thumbnailUrl;

  /// Whether this video has valid aspect ratio information.
  bool get validAspectRatio => aspectRatio?.length == 2;

  /// The [aspectRatio] as a double.
  double get aspectRatioDouble => aspectRatio[0] / aspectRatio[1];
}
