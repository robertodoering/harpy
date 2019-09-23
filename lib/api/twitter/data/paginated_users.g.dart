// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedUsers _$PaginatedUsersFromJson(Map<String, dynamic> json) {
  return PaginatedUsers()
    ..users = (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..nextCursor = json['next_cursor'] as int
    ..nextCursorStr = json['next_cursor_str'] as String
    ..previousCursor = json['previous_cursor'] as int
    ..previousCursorStr = json['previous_cursor_str'] as String;
}

Map<String, dynamic> _$PaginatedUsersToJson(PaginatedUsers instance) =>
    <String, dynamic>{
      'users': instance.users,
      'next_cursor': instance.nextCursor,
      'next_cursor_str': instance.nextCursorStr,
      'previous_cursor': instance.previousCursor,
      'previous_cursor_str': instance.previousCursorStr,
    };
