import 'package:dart_twitter_api/twitter_api.dart';

abstract class MediaData {
  /// The url based on the media quality settings.
  String get appropriateUrl;

  /// The url with the best quality available.
  String get bestUrl;
}

/// The image data for a [TweetData].
class ImageData extends MediaData {
  ImageData.fromMedia(Media media) {
    if (media == null) {
      return;
    }

    baseUrl = media.mediaUrlHttps;
  }

  ImageData.fromImageUrl(this.baseUrl);

  /// The base url for the image.
  String baseUrl;

  String get thumb => '$baseUrl?name=thumb&format=jpg';
  String get small => '$baseUrl?name=small&format=jpg';
  String get medium => '$baseUrl?name=medium&format=jpg';
  String get large => '$baseUrl?name=large&format=jpg';

  /// The image url used to download the image.
  @override
  String get bestUrl => '$baseUrl?name=large&format=png';

  /// The image url for images drawn in the app.
  @override
  String get appropriateUrl => small;
}

/// The video (and animated gif) data for a [TweetData].
class VideoData extends MediaData {
  VideoData.fromMedia(Media media) {
    aspectRatio = media.videoInfo.aspectRatio;

    // removes variants that does not have a bitrate (content type:
    // 'application/x-mpegURL') and then sorts them by the bitrate descending
    // (highest quality first)
    variants = media.videoInfo.variants
        .where((Variant variant) => variant.bitrate != null)
        .toList()
          ..sort((Variant a, Variant b) => b.bitrate.compareTo(a.bitrate));

    thumbnail = ImageData.fromImageUrl(media.mediaUrlHttps);
  }

  /// The aspect ratio of the video.
  List<int> aspectRatio;

  /// The video variants sorted by their quality (best quality first).
  List<Variant> variants;

  /// The url for a thumbnail image of the video.
  ImageData thumbnail;

  /// Returns the appropriate thumbnail url.
  String get thumbnailUrl => thumbnail?.appropriateUrl;

  /// Whether this video has valid aspect ratio information.
  bool get validAspectRatio => aspectRatio?.length == 2;

  /// The [aspectRatio] as a double.
  double get aspectRatioDouble => aspectRatio[0] / aspectRatio[1];

  /// Returns the video url based on the media setting and connectivity.
  ///
  /// Returns an empty string if no video [variants] exist.
  @override
  String get appropriateUrl {
    if (variants?.isNotEmpty == true) {
      return variants[0].url;
    } else {
      return '';
    }
  }

  /// The url of the variant with the best quality.
  @override
  String get bestUrl {
    if (variants?.isNotEmpty == true) {
      return variants[0].url;
    } else {
      return '';
    }
  }
}
