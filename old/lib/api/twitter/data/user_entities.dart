import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entities.g.dart';

@JsonSerializable()
class UserEntities {
  UserEntities();

  factory UserEntities.fromJson(Map<String, dynamic> json) =>
      _$UserEntitiesFromJson(json);

  UserEntityUrl url;
  UserEntityUrl description;

  Map<String, dynamic> toJson() => _$UserEntitiesToJson(this);

  /// Returns the [description] as the [urls] of an [Entities] object.
  Entities get asEntities => Entities()..urls = description.urls;
}

@JsonSerializable()
class UserEntityUrl {
  UserEntityUrl(this.urls);

  factory UserEntityUrl.fromJson(Map<String, dynamic> json) =>
      _$UserEntityUrlFromJson(json);

  List<Url> urls;

  Map<String, dynamic> toJson() => _$UserEntityUrlToJson(this);
}
