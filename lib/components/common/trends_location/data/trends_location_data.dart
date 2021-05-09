import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trends_location_data.g.dart';

@immutable
@JsonSerializable()
class TrendsLocationData {
  const TrendsLocationData({
    required this.name,
    required this.woeid,
    required this.placeType,
  });

  factory TrendsLocationData.fromJson(Map<String, dynamic> json) =>
      _$TrendsLocationDataFromJson(json);

  /// The Yahoo! Where On Earth ID of the location to return trending
  /// information for. Global information is available by using 1 as the
  /// `WOEID`.
  final int woeid;

  /// The name of the place (e.g. name of country).
  final String name;

  /// The name of the place type (e.g. 'Country', 'Town').
  final String placeType;

  Map<String, dynamic> toJson() => _$TrendsLocationDataToJson(this);
}
