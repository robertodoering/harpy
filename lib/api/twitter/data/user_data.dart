import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';

part 'user_data.freezed.dart';

@freezed
class LegacyUserData with _$LegacyUserData {
  factory LegacyUserData({
    @Default('') String id,

    /// The display name of the user.
    ///
    /// e.g. 'harpy'.
    @Default('') String name,

    /// The handle or alias that this user identifies themselves with.
    ///
    /// Handles are unique but subject to change.
    ///
    /// Typically a maximum of 15 characters long, but some historical accounts
    /// may exist with longer names.
    ///
    /// e.g. 'harpy_app'.
    @Default('') String handle,
    @Default(false) bool verified,
    @Default(0) int followersCount,

    /// The number of users this user is following.
    @Default(0) int friendsCount,
    @Default('') String profileImageUrl,

    // optional user fields

    String? profileBannerUrl,
    DateTime? createdAt,
    String? location,
    String? description,

    // custom fields

    UrlData? userUrl,
    @Default(<UrlData>[]) List<UrlData> userDescriptionUrls,
    Translation? descriptionTranslation,
    @Default(EntitiesData()) EntitiesData userDescriptionEntities,

    /// Whether the description is currently being translated.
    @Default(false) bool isTranslatingDescription,
  }) = _UserData;

  /// Parses the [LegacyUserData] from the [TwitterApi] returned [User] object.
  factory LegacyUserData.fromUser(User? user) {
    final userUrl = user?.entities?.url?.urls != null &&
            user!.entities!.url!.urls!.isNotEmpty
        ? UrlData.fromUrl(user.entities!.url!.urls!.first)
        : null;

    final userDescriptionUrls =
        user?.entities?.description?.urls?.map(UrlData.fromUrl).toList() ?? [];

    return LegacyUserData(
      // required
      id: user?.idStr ?? '',
      name: user?.name ?? '',
      handle: user?.screenName ?? '',
      verified: user?.verified ?? false,
      followersCount: user?.followersCount ?? 0,
      friendsCount: user?.friendsCount ?? 0,
      profileImageUrl: user?.profileImageUrlHttps ?? '',
      // optional
      profileBannerUrl: user?.profileBannerUrl,
      createdAt: user?.createdAt,
      location: user?.location,
      description: user?.description,
      // custom
      userUrl: userUrl,
      userDescriptionUrls: userDescriptionUrls,
      userDescriptionEntities: _userDescriptionEntities(
        userDescriptionUrls,
        user?.description,
      ),
    );
  }

  LegacyUserData._();

  late final hasDescription = description != null && description!.isNotEmpty;
  late final hasUrl = userUrl != null;
  late final hasLocation = location != null && location!.isNotEmpty;
  late final hasCreatedAt = createdAt != null;
  late final hasBanner = profileBannerUrl != null;
  late final appropriateUserImageUrl = profileImageUrl.replaceFirst(
    '_normal',
    '_bigger',
  );
  late final originalUserImageUrl = profileImageUrl.replaceAll('_normal', '');
  late final appropriateUserBannerUrl = '$profileBannerUrl/1500x500';
}

EntitiesData _userDescriptionEntities(
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
