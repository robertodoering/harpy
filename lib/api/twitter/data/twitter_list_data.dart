import 'package:dart_twitter_api/twitter_api.dart' as v1;
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

  factory TwitterListData.fromV1(v1.TwitterList list) {
    return TwitterListData(
      name: list.name ?? '',
      createdAt: list.createdAt,
      subscriberCount: list.subscriberCount,
      id: list.idStr ?? '',
      memberCount: list.memberCount,
      mode: list.mode ?? 'public',
      description: list.description ?? '',
      user: list.user != null ? UserData.fromV1(list.user!) : null,
      following: list.following ?? false,
    );
  }

  TwitterListData._();

  late final isPrivate = mode == 'private';
  late final isPublic = !isPrivate;
}
