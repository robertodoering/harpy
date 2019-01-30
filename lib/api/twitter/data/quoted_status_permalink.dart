import 'package:json_annotation/json_annotation.dart';

part 'quoted_status_permalink.g.dart';

@JsonSerializable()
class QuotedStatusPermalink {
  String url;
  String expanded;
  String display;

  QuotedStatusPermalink();

  factory QuotedStatusPermalink.fromJson(Map<String, dynamic> json) =>
      _$QuotedStatusPermalinkFromJson(json);

  Map<String, dynamic> toJson() => _$QuotedStatusPermalinkToJson(this);
}
