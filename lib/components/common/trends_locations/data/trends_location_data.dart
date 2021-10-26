import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:harpy/core/core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trends_location_data.g.dart';

@JsonSerializable()
class TrendsLocationData extends Equatable {
  const TrendsLocationData({
    required this.name,
    required this.woeid,
    required this.placeType,
    required this.country,
  });

  factory TrendsLocationData.fromJson(Map<String, dynamic> json) =>
      _$TrendsLocationDataFromJson(json);

  /// Returns the [TrendsLocationData] from the preferences or [worldwide] if
  /// none is set.
  factory TrendsLocationData.fromPreferences() {
    final jsonString = app<TrendsPreferences>().trendsLocation;

    if (jsonString.isNotEmpty) {
      try {
        return TrendsLocationData.fromJson(jsonDecode(jsonString));
      } catch (e) {
        // ignore
      }
    }

    return worldwide;
  }

  /// The data for the worldwide location (as returned from twitter).
  static const worldwide = TrendsLocationData(
    name: 'Worldwide',
    woeid: 1,
    placeType: 'Supername',
    country: '',
  );

  /// The Yahoo! Where On Earth ID of the location to return trending
  /// information for. Global information is available by using 1 as the
  /// `WOEID`.
  final int woeid;

  /// The name of the place (e.g. name of country).
  final String name;

  /// The name of the place type (e.g. 'Country', 'Town').
  final String placeType;

  /// The name of the country this place belongs to.
  final String country;

  bool get isCountry => placeType == 'Country';

  bool get isTown => placeType == 'Town';

  bool get hasCountry => country.isNotEmpty;

  @override
  List<Object?> get props => [woeid, name, placeType, country];

  Map<String, dynamic> toJson() => _$TrendsLocationDataToJson(this);
}
