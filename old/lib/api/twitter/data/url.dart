import 'package:json_annotation/json_annotation.dart';

part 'url.g.dart';

@JsonSerializable()
class Url {
  Url();

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

  String url;
  @JsonKey(name: "expanded_url")
  String expandedUrl;
  @JsonKey(name: "display_url")
  String displayUrl;
  List<int> indices;

  Map<String, dynamic> toJson() => _$UrlToJson(this);
}
