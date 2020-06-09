import 'package:json_annotation/json_annotation.dart';

part 'video_info.g.dart';

@JsonSerializable()
class VideoInfo {
  VideoInfo();

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  @JsonKey(name: "aspect_ratio")
  List<int> aspectRatio;
  @JsonKey(name: "duration_millis")
  int durationMillis;
  List<Variants> variants;

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}

@JsonSerializable()
class Variants {
  Variants();

  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);

  int bitrate;
  @JsonKey(name: "content_type")
  String contentType;
  String url;

  Map<String, dynamic> toJson() => _$VariantsToJson(this);
}
