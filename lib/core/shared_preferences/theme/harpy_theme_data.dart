import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HarpyThemeData {
  int primaryColor;
  int accentColor;

  HarpyThemeData(
    this.primaryColor,
    this.accentColor,
  );
}
