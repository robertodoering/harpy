import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_twitter_api/twitter_api.dart' as v1;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

part 'media_data.freezed.dart';

mixin MediaData {
  /// The url with the best quality available.
  String get bestUrl;

  /// The aspect ratio of the image or video.
  double get aspectRatioDouble;

  MediaType get type;

  /// The url based on the media quality settings.
  String appropriateUrl(
    MediaPreferences mediaPreferences,
    ConnectivityResult connectivity,
  );
}

@freezed
class ImageMediaData with _$ImageMediaData, MediaData {
  factory ImageMediaData({
    /// The base url for the image.
    required String baseUrl,

    /// The aspect ratio of the image.
    ///
    /// The [large] size is used to calculate the aspect ratio but should be the
    /// same as [small] and [medium].
    ///
    /// [thumb] sized images are always in a 1:1 aspect ratio.
    required double aspectRatioDouble,
  }) = _ImageMediaData;

  factory ImageMediaData.fromV1(v1.Media media) {
    final aspectRatioDouble =
        (media.sizes?.large?.w ?? 16) / (media.sizes?.large?.h ?? 9);

    return ImageMediaData(
      baseUrl: media.mediaUrlHttps ?? '',
      aspectRatioDouble: aspectRatioDouble,
    );
  }

  ImageMediaData._();

  @override
  late final type = MediaType.image;

  /// The image url used to download the image.
  @override
  late final bestUrl = '$baseUrl?name=large&format=png';

  late final thumb = '$baseUrl?name=thumb&format=jpg';
  late final small = '$baseUrl?name=small&format=jpg';
  late final medium = '$baseUrl?name=medium&format=jpg';
  late final large = '$baseUrl?name=large&format=jpg';

  /// The image url for images drawn in the app.
  @override
  String appropriateUrl(
    MediaPreferences mediaPreferences,
    ConnectivityResult connectivity,
  ) {
    return mediaPreferences.shouldUseBestMediaQuality(connectivity)
        ? bestUrl
        : small;
  }
}

@freezed
class VideoMediaData with _$VideoMediaData, MediaData {
  factory VideoMediaData({
    required double aspectRatioDouble,
    required Duration? duration,

    /// The video urls sorted by their quality (best quality first).
    required List<String> variants,

    /// The url for a thumbnail image of the video.
    required ImageMediaData thumbnail,
    required MediaType type,
  }) = _VideoMediaData;

  factory VideoMediaData.fromV1(v1.Media media) {
    final aspectRatio = media.videoInfo?.aspectRatio ?? [];

    final aspectRatioDouble =
        aspectRatio.length == 2 ? aspectRatio[0] / aspectRatio[1] : 16 / 9;

    final durationMillis = media.videoInfo?.durationMillis;

    // removes variants that does not have a bitrate (content type:
    // 'application/x-mpeg') and then sorts them by the bitrate descending
    // (highest quality first)
    final variants = media.videoInfo?.variants
        ?.where((variant) => variant.bitrate != null)
        .where((variant) => variant.url != null && variant.url!.isNotEmpty)
        .toList()
      ?..sort((a, b) => b.bitrate!.compareTo(a.bitrate!));

    final thumbnail = ImageMediaData(
      baseUrl: media.mediaUrlHttps ?? '',
      aspectRatioDouble: aspectRatioDouble,
    );

    assert(media.type == kMediaVideo || media.type == kMediaGif);

    return VideoMediaData(
      aspectRatioDouble: aspectRatioDouble,
      duration: durationMillis != null
          ? Duration(milliseconds: durationMillis)
          : null,
      variants: variants
              ?.map((variant) => variant.url)
              .whereType<String>()
              .toList() ??
          [],
      thumbnail: thumbnail,
      type: media.type == kMediaGif ? MediaType.gif : MediaType.video,
    );
  }

  VideoMediaData._();

  /// The video url for videos (and gifs) shown in the app.
  ///
  /// This is the same as [bestUrl] because the quality for worse variants is
  /// too bad.
  @override
  String appropriateUrl(
    MediaPreferences mediaPreferences,
    ConnectivityResult connectivity,
  ) {
    return bestUrl;
  }

  /// The url of the variant with the best quality.
  @override
  late final bestUrl = variants.isNotEmpty ? variants.first : '';
}
