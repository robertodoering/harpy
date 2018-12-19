import 'package:json_annotation/json_annotation.dart';

part 'harpy_data.g.dart';

@JsonSerializable()
class HarpyData {
  @JsonKey(name: "show_media")
  bool showMedia;

  HarpyData.init();

  HarpyData(this.showMedia);

  factory HarpyData.fromJson(Map<String, dynamic> json) =>
      _$HarpyDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyDataToJson(this);
}
