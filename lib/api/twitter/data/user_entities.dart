import 'package:harpy/api/twitter/data/url.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entities.g.dart';

@JsonSerializable()
class UserEntities {
  List<Url> url;
  List<Url> description;

  UserEntities(this.url, this.description);

  factory UserEntities.fromJson(Map<String, dynamic> json) =>
      _$UserEntitiesFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntitiesToJson(this);
}
