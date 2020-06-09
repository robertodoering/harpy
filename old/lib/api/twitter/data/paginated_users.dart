import 'package:harpy/api/twitter/data/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_users.g.dart';

@JsonSerializable()
class PaginatedUsers {
  PaginatedUsers();

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersFromJson(json);

  List<User> users;
  @JsonKey(name: "next_cursor")
  int nextCursor;
  @JsonKey(name: "next_cursor_str")
  String nextCursorStr;
  @JsonKey(name: "previous_cursor")
  int previousCursor;
  @JsonKey(name: "previous_cursor_str")
  String previousCursorStr;

  bool get lastPage => nextCursor == -1;

  Map<String, dynamic> toJson() => _$PaginatedUsersToJson(this);
}
