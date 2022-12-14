import 'package:dart_twitter_api/twitter_api.dart' as v1;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    required String handle,
    String? description,
    EntitiesData? descriptionEntities,
    UrlData? url,
    UserProfileImage? profileImage,
    String? location,
    @Default(false) bool isProtected,
    @Default(false) bool isVerified,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int tweetCount,
    DateTime? createdAt,
  }) = _UserData;

  factory UserData.fromV2(v2.UserData user) {
    return UserData(
      id: user.id,
      name: user.name,
      handle: user.username,
      description: user.description?.isEmpty ?? false ? null : user.description,
      descriptionEntities: user.entities?.description != null
          ? EntitiesData.fromV2UserDescriptionEntity(
              user.entities!.description!,
            )
          : null,
      url: user.entities?.url?.urls != null &&
              user.entities!.url!.urls.isNotEmpty
          ? UrlData.fromV2(user.entities!.url!.urls.first)
          : null,
      profileImage: user.profileImageUrl != null
          ? UserProfileImage.fromUrl(user.profileImageUrl!)
          : null,
      location: user.location,
      isProtected: user.isProtected ?? false,
      isVerified: user.isVerified ?? false,
      followersCount: user.publicMetrics?.followersCount ?? 0,
      followingCount: user.publicMetrics?.followingCount ?? 0,
      tweetCount: user.publicMetrics?.tweetCount ?? 0,
      createdAt: user.createdAt,
    );
  }

  factory UserData.fromV1(v1.User user) {
    final userUrl =
        user.entities?.url?.urls != null && user.entities!.url!.urls!.isNotEmpty
            ? UrlData.fromV1(user.entities!.url!.urls!.first)
            : null;

    final userDescriptionUrls =
        user.entities?.description?.urls?.map(UrlData.fromV1).toList() ?? [];

    return UserData(
      id: user.idStr ?? '',
      name: user.name ?? '',
      handle: user.screenName ?? '',
      description: user.description?.isEmpty ?? false ? null : user.description,
      descriptionEntities: _v1UserDescriptionEntities(
        userDescriptionUrls,
        user.description,
      ),
      url: userUrl,
      profileImage: user.profileImageUrlHttps != null
          ? UserProfileImage.fromUrl(user.profileImageUrlHttps!)
          : null,
      location: user.location,
      isProtected: user.protected ?? false,
      isVerified: user.verified ?? false,
      followersCount: user.followersCount ?? 0,
      followingCount: user.friendsCount ?? 0,
      createdAt: user.createdAt,
    );
  }
}

@freezed
class UserProfileImage with _$UserProfileImage {
  const factory UserProfileImage({
    required Uri? mini,
    required Uri? normal,
    required Uri? bigger,
    required Uri? original,
  }) = _UserProfileImage;

  factory UserProfileImage.fromUrl(String profileImageUrl) {
    return UserProfileImage(
      mini: Uri.tryParse(profileImageUrl.replaceAll('_normal', '_mini')),
      normal: Uri.tryParse(profileImageUrl),
      bigger: Uri.tryParse(profileImageUrl.replaceAll('_normal', '_bigger')),
      original: Uri.tryParse(profileImageUrl.replaceAll('_normal', '')),
    );
  }
}

EntitiesData _v1UserDescriptionEntities(
  List<UrlData> userDescriptionUrls,
  String? description,
) {
  if (description != null) {
    final descriptionEntities = parseEntities(description);

    return descriptionEntities.copyWith(
      urls: userDescriptionUrls.toList(),
    );
  } else {
    return EntitiesData(
      urls: userDescriptionUrls.toList(),
    );
  }
}
