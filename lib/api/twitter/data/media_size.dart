import 'package:json_annotation/json_annotation.dart';

part 'media_size.g.dart';

@JsonSerializable()
class MediaSize {
  MediaSize();

  factory MediaSize.fromJson(Map<String, dynamic> json) =>
      _$MediaSizeFromJson(json);

  int w;
  int h;
  String resize;

  Map<String, dynamic> toJson() => _$MediaSizeToJson(this);
}
