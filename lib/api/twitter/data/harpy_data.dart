import 'package:harpy/api/translate/data/translation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_data.g.dart';

@JsonSerializable()
class HarpyData {
  HarpyData();

  factory HarpyData.fromJson(Map<String, dynamic> json) =>
      _$HarpyDataFromJson(json);

  bool showMedia;
  Translation translation;
  bool parentOfReply;
  bool childOfReply;

  Map<String, dynamic> toJson() => _$HarpyDataToJson(this);
}
