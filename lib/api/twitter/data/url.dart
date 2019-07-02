import 'package:json_annotation/json_annotation.dart';

part 'url.g.dart';

@JsonSerializable()
class Url {
  Url(this.url, this.expandedUrl, this.displayUrl, this.indices);

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "expanded_url")
  String expandedUrl;
  @JsonKey(name: "display_url")
  String displayUrl;
  @JsonKey(name: "indices")
  List<int> indices;

  Map<String, dynamic> toJson() => _$UrlToJson(this);

  @override
  String toString() {
    return 'Url{url: $url, expandedUrl: $expandedUrl, displayUrl: $displayUrl, indices: $indices}';
  }
}
