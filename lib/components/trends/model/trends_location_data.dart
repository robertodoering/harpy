import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_location_data.freezed.dart';
part 'trends_location_data.g.dart';

@freezed
class TrendsLocationData with _$TrendsLocationData {
  factory TrendsLocationData({
    /// The Yahoo! Where On Earth ID of the location to return trending
    /// information for. Global information is available by using 1 as the
    /// `WOEID`.
    required int woeid,

    /// The name of the place (e.g. name of country).
    required String name,

    /// The name of the place type (e.g. 'Country', 'Town').
    required String placeType,

    /// The name of the country this place belongs to.
    required String? country,
  }) = _TrendsLocationData;

  TrendsLocationData._();

  factory TrendsLocationData.worldwide() => TrendsLocationData(
        name: 'Worldwide',
        woeid: 1,
        placeType: 'Supername',
        country: '',
      );

  factory TrendsLocationData.fromJson(Map<String, dynamic> json) =>
      _$TrendsLocationDataFromJson(json);

  late final isCountry = placeType == 'Country';
  late final isTown = placeType == 'Town';

  late final displayName = woeid == 1 ? 'worldwide trends' : 'trends in $name';
}
