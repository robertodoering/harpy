import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';

part 'user_search_state.freezed.dart';

@freezed
class UsersSearchStateData with _$UsersSearchStateData {
  const factory UsersSearchStateData({
    required BuiltList<UserData> users,
    required String query,
  }) = _UsersSearchStateData;
}
