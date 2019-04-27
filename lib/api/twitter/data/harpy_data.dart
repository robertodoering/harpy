import 'package:harpy/api/translate/data/translation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_data.g.dart';

@JsonSerializable()
class HarpyData {
  bool showMedia;
  Translation translation;
  bool parentOfReply;
  bool childOfReply;

  HarpyData.init();

  HarpyData(
    this.showMedia,
    this.translation,
    this.parentOfReply,
    this.childOfReply,
  );

  factory HarpyData.fromJson(Map<String, dynamic> json) =>
      _$HarpyDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyDataToJson(this);

  @override
  String toString() {
    return 'HarpyData{showMedia: $showMedia, translation: $translation, parentOfReply: $parentOfReply, childOfReply: $childOfReply}';
  }
}
