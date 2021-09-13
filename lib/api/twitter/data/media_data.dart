import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/core.dart';

abstract class MediaData {
  /// The url based on the media quality settings.
  String? get appropriateUrl;

  /// The url with the best quality available.
  String? get bestUrl;

  /// The aspect ratio of the image or video.
  double get aspectRatioDouble;
}

/// The image data for a tweet.
class ImageData extends MediaData {
  ImageData.fromMedia(Media media) {
    baseUrl = media.mediaUrlHttps ?? '';

    if (media.sizes?.large?.w != null && media.sizes?.large?.h != null) {
      aspectRatio = media.sizes!.large!.w! / media.sizes!.large!.h!;
    } else {
      aspectRatio = 16 / 9;
    }
  }

  ImageData.fromImageUrl(this.baseUrl, this.aspectRatio);

  /// The base url for the image.
  late String baseUrl;

  /// The aspect ratio of the image.
  ///
  /// The [large] size is used to calculate the aspect ratio but should be the
  /// same as [small] and [medium].
  ///
  /// [thumb] sized images are always in a 1:1 aspect ratio.
  late double aspectRatio;

  String get thumb => '$baseUrl?name=thumb&format=jpg';
  String get small => '$baseUrl?name=small&format=jpg';
  String get medium => '$baseUrl?name=medium&format=jpg';
  String get large => '$baseUrl?name=large&format=jpg';

  @override
  double get aspectRatioDouble => aspectRatio;

  /// The image url used to download the image.
  @override
  String get bestUrl => '$baseUrl?name=large&format=png';

  /// The image url for images drawn in the app.
  ///
  /// Returns the [bestUrl] if [MediaPreferences.bestMediaQuality] is
  /// `true`, or [small] otherwise.
  @override
  String get appropriateUrl {
    return app<MediaPreferences>().shouldUseBestMediaQuality ? bestUrl : small;
  }
}

/// The video (and animated gif) data for a tweet.
class VideoData extends MediaData {
  VideoData.fromMedia(Media media) {
    aspectRatio = media.videoInfo!.aspectRatio ?? <int>[];

    // removes variants that does not have a bitrate (content type:
    // 'application/x-mpegURL') and then sorts them by the bitrate descending
    // (highest quality first)
    variants = media.videoInfo!.variants!
        .where((variant) => variant.bitrate != null)
        .toList()
      ..sort((a, b) => b.bitrate!.compareTo(a.bitrate!));

    thumbnail = ImageData.fromImageUrl(
      media.mediaUrlHttps ?? '',
      aspectRatioDouble,
    );
  }

  /// The aspect ratio of the video.
  late List<int> aspectRatio;

  /// The video variants sorted by their quality (best quality first).
  late List<Variant> variants;

  /// The url for a thumbnail image of the video.
  late ImageData thumbnail;

  /// Returns the appropriate thumbnail url.
  String? get thumbnailUrl => thumbnail.appropriateUrl;

  /// Whether this video has valid aspect ratio information.
  bool get validAspectRatio => aspectRatio.length == 2;

  /// The [aspectRatio] as a double.
  @override
  double get aspectRatioDouble =>
      aspectRatio.length == 2 ? aspectRatio[0] / aspectRatio[1] : 16 / 9;

  /// The video url for videos (and gifs) shown in the app.
  ///
  /// This is the same as [bestUrl] because the quality for worse variants is
  /// too bad.
  @override
  String? get appropriateUrl {
    return bestUrl;
  }

  /// The url of the variant with the best quality.
  @override
  String? get bestUrl {
    if (variants.isNotEmpty) {
      return variants.first.url;
    } else {
      return '';
    }
  }
}
