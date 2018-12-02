import 'package:harpy/api/twitter/data/media_size.dart';
import 'package:harpy/api/twitter/data/video_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'twitter_media.g.dart';

@JsonSerializable()
class TwitterMedia {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "id_str")
  String idStr;
  @JsonKey(name: "indices")
  List<int> indices;
  @JsonKey(name: "media_url")
  String mediaUrl;
  @JsonKey(name: "media_url_https")
  String mediaUrlHttps;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "display_url")
  String displayUrl;
  @JsonKey(name: "expanded_url")
  String expandedUrl;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "sizes")
  Map<String, MediaSize> sizes;
  @JsonKey(name: "video_info")
  VideoInfo videoInfo;

  TwitterMedia(
    this.id,
    this.idStr,
    this.indices,
    this.mediaUrl,
    this.mediaUrlHttps,
    this.url,
    this.displayUrl,
    this.expandedUrl,
    this.type,
    this.sizes,
    this.videoInfo,
  );

  factory TwitterMedia.fromJson(Map<String, dynamic> json) =>
      _$TwitterMediaFromJson(json);

  Map<String, dynamic> toJson() => _$TwitterMediaToJson(this);

  @override
  String toString() {
    return 'TwitterMedia{id: $id, idStr: $idStr, indices: $indices, mediaUrl: $mediaUrl, mediaUrlHttps: $mediaUrlHttps, url: $url, displayUrl: $displayUrl, expandedUrl: $expandedUrl, type: $type, sizes: $sizes}';
  }
}
