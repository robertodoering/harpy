import 'package:json_annotation/json_annotation.dart';

part 'media_size.g.dart';

@JsonSerializable()
class MediaSize {
  @JsonKey(name: "w")
  int w;
  @JsonKey(name: "h")
  int h;
  @JsonKey(name: "resize")
  String resize;

  MediaSize(this.w, this.h, this.resize);

  factory MediaSize.fromJson(Map<String, dynamic> json) =>
      _$MediaSizeFromJson(json);

  Map<String, dynamic> toJson() => _$MediaSizeToJson(this);

  @override
  String toString() {
    return 'MediaSize{w: $w, h: $h, resize: $resize}';
  }
}
