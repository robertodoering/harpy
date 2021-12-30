import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';

class UserData extends Equatable {
  const UserData({
    this.id = '',
    this.name = '',
    this.handle = '',
    this.verified = false,
    this.followersCount = 0,
    this.friendsCount = 0,
    this.profileImageUrl = '',
    this.profileBannerUrl,
    this.createdAt,
    this.location,
    this.description,
    this.descriptionTranslation,
    this.userUrl,
    this.userDescriptionUrls = const [],
    this.userDescriptionEntities = const EntitiesData(),
  });

  /// Parses the [UserData] from the [TwitterApi] returned [User] object.
  factory UserData.fromUser(User? user) {
    final userUrl = user?.entities?.url?.urls != null &&
            user!.entities!.url!.urls!.isNotEmpty
        ? UrlData.fromUrl(user.entities!.url!.urls!.first)
        : null;

    final userDescriptionUrls =
        user?.entities?.description?.urls?.map(UrlData.fromUrl).toList() ?? [];

    return UserData(
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

  // required user fields

  final String id;

  /// The display name of the user.
  ///
  /// e.g. 'Google Developers'.
  final String name;

  /// The handle or alias that this user identifies themselves with.
  ///
  /// Handles are unique but subject to change.
  ///
  /// Typically a maximum of 15 characters long, but some historical accounts
  /// may exist with longer names.
  ///
  /// e.g. 'googledevs'.
  final String handle;

  final bool verified;
  final int followersCount;

  /// The number of users this user is following.
  final int friendsCount;

  final String profileImageUrl;

  // optional user fields

  final String? profileBannerUrl;
  final DateTime? createdAt;
  final String? location;
  final String? description;

  // custom fields

  final UrlData? userUrl;
  final List<UrlData> userDescriptionUrls;
  final Translation? descriptionTranslation;

  final EntitiesData userDescriptionEntities;

  UserData copyWith({
    String? id,
    String? name,
    String? handle,
    bool? verified,
    int? followersCount,
    int? friendsCount,
    String? profileBannerUrl,
    String? profileImageUrl,
    DateTime? createdAt,
    String? location,
    String? description,
    UrlData? userUrl,
    List<UrlData>? userDescriptionUrls,
    Translation? descriptionTranslation,
    EntitiesData? userDescriptionEntities,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      verified: verified ?? this.verified,
      followersCount: followersCount ?? this.followersCount,
      friendsCount: friendsCount ?? this.friendsCount,
      profileBannerUrl: profileBannerUrl ?? this.profileBannerUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      description: description ?? this.description,
      userUrl: userUrl ?? this.userUrl,
      userDescriptionUrls: userDescriptionUrls ?? this.userDescriptionUrls,
      descriptionTranslation:
          descriptionTranslation ?? this.descriptionTranslation,
      userDescriptionEntities:
          userDescriptionEntities ?? this.userDescriptionEntities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        handle,
        verified,
        followersCount,
        friendsCount,
        profileBannerUrl,
        profileImageUrl,
        createdAt,
        location,
        description,
        userUrl,
        userDescriptionUrls,
        descriptionTranslation,
        userDescriptionEntities,
      ];
}

extension UserDataExtension on UserData {
  bool get hasDescriptionTranslation => descriptionTranslation != null;

  bool get hasDescription => description != null && description!.isNotEmpty;

  bool get hasUrl => userUrl != null;

  bool get hasLocation => location != null && location!.isNotEmpty;

  bool get hasCreatedAt => createdAt != null;

  bool get hasBanner => profileBannerUrl != null;

  String get appropriateUserImageUrl =>
      profileImageUrl.replaceFirst('_normal', '_bigger');

  String get originalUserImageUrl => profileImageUrl.replaceAll('_normal', '');

  String get appropriateUserBannerUrl => '$profileBannerUrl/web_retina';
}

EntitiesData _userDescriptionEntities(
  List<UrlData> userDescriptionUrls,
  String? description,
) {
  if (description != null) {
    final descriptionEntities = parseEntities(description);

    return descriptionEntities.copyWith(
      urls: userDescriptionUrls,
    );
  } else {
    return EntitiesData(
      urls: userDescriptionUrls,
    );
  }
}
