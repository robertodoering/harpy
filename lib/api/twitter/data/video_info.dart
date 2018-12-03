import 'package:json_annotation/json_annotation.dart';

part 'video_info.g.dart';

@JsonSerializable()
class VideoInfo {
  @JsonKey(name: "aspect_ratio")
  List<int> aspectRatio;

  @JsonKey(name: "duration_millis")
  int durationMillis;

  @JsonKey(name: "variants")
  List<Variants> variants;

  VideoInfo(this.aspectRatio, this.durationMillis, this.variants);

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}

@JsonSerializable()
class Variants {
  @JsonKey(name: "bitrate")
  int bitrate;

  @JsonKey(name: "content_type")
  String contentType;

  @JsonKey(name: "url")
  String url;

  Variants(this.bitrate, this.contentType, this.url);

  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);

  Map<String, dynamic> toJson() => _$VariantsToJson(this);

  @override
  String toString() {
    return 'Variants{bitrate: $bitrate, contentType: $contentType, url: $url}';
  }
}
