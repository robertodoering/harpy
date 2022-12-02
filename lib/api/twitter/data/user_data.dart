import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    required String handle,
    String? description,
    Uri? url,
    Uri? profileImageUrl,
    String? location,
    @Default(false) bool isProtected,
    @Default(false) bool isVerified,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int tweetCount,
  }) = _UserData;

  factory UserData.fromV2(v2.UserData user) {
    return UserData(
      id: user.id,
      name: user.name,
      handle: user.username,
      description: user.description,
      url: user.url != null ? Uri.tryParse(user.url!) : null,
      profileImageUrl: user.profileImageUrl != null
          ? Uri.tryParse(user.profileImageUrl!)
          : null,
      location: user.location,
      isProtected: user.isProtected ?? false,
      isVerified: user.isVerified ?? false,
      followersCount: user.publicMetrics?.followersCount ?? 0,
      followingCount: user.publicMetrics?.followingCount ?? 0,
      tweetCount: user.publicMetrics?.tweetCount ?? 0,
    );
  }
}
