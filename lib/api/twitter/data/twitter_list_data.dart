import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';

part 'twitter_list_data.freezed.dart';

@freezed
class TwitterListData with _$TwitterListData {
  factory TwitterListData({
    @Default('') String name,
    DateTime? createdAt,
    int? subscriberCount,
    @Default('') String id,
    int? memberCount,

    /// Can be 'private' or 'public'.
    @Default('public') String mode,
    @Default('') String description,
    UserData? user,
    @Default(false) bool following,
  }) = _TwitterListData;

  TwitterListData._();

  late final isPrivate = mode == 'private';
  late final isPublic = !isPrivate;
}
