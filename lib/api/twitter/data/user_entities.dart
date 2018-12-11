import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entities.g.dart';

@JsonSerializable()
class UserEntities {
  UserEntityUrl url;
  UserEntityUrl description;

  UserEntities(this.url, this.description);

  factory UserEntities.fromJson(Map<String, dynamic> json) =>
      _$UserEntitiesFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntitiesToJson(this);

  /// Returns the [description] as the [urls] of an [Entities] object.
  Entities get asEntities =>
      Entities(null, null, description.urls, null, null, null);
}

@JsonSerializable()
class UserEntityUrl {
  List<Url> urls;

  UserEntityUrl(this.urls);

  factory UserEntityUrl.fromJson(Map<String, dynamic> json) =>
      _$UserEntityUrlFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityUrlToJson(this);
}
