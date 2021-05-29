import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';

@immutable
class UserData extends Equatable {
  const UserData({
    required this.id,
    required this.name,
    required this.handle,
    required this.verified,
    required this.followersCount,
    required this.friendsCount,
    required this.userDescriptionEntities,
    required this.userDescriptionUrls,
    this.profileBannerUrl,
    this.profileImageUrl,
    this.createdAt,
    this.location,
    this.description,
    this.descriptionTranslation,
    this.userUrl,
    this.connections,
  });

  /// Parses the [UserData] from the [TwitterApi] returned [User] object.
  factory UserData.fromUser(User? user) {
    final userUrl = user?.entities?.url?.urls != null &&
            user!.entities!.url!.urls!.isNotEmpty
        ? UrlData.fromUrl(user.entities!.url!.urls!.first)
        : null;

    final userDescriptionUrls = user?.entities?.description?.urls
            ?.map((url) => UrlData.fromUrl(url))
            .toList() ??
        [];

    return UserData(
      // required
      id: user?.idStr ?? '',
      name: user?.name ?? '',
      handle: user?.screenName ?? '',
      verified: user?.verified ?? false,
      followersCount: user?.followersCount ?? 0,
      friendsCount: user?.friendsCount ?? 0,
      // optional
      profileBannerUrl: user?.profileBannerUrl,
      profileImageUrl: user?.profileImageUrlHttps,
      createdAt: user?.createdAt,
      location: user?.location,
      description: user?.description,
      // custom
      userUrl: userUrl,
      userDescriptionUrls: userDescriptionUrls,
      connections: const [],
      userDescriptionEntities: const EntitiesData(
        hashtags: [],
        urls: [],
        userMentions: [],
        media: [],
      ),
    );
  }

  // required user fields

  final String id;
  final String name;
  final String handle;
  final bool verified;
  final int followersCount;
  final int friendsCount;

  // optional user fields

  final String? profileBannerUrl;
  final String? profileImageUrl;

  final DateTime? createdAt;
  final String? location;
  final String? description;

  // custom fields

  final UrlData? userUrl;

  final List<UrlData> userDescriptionUrls;

  final Translation? descriptionTranslation;

  final List<String>? connections;

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
    List<String>? connections,
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
      connections: connections ?? this.connections,
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
        connections,
        userDescriptionEntities,
      ];
}

extension UserDataExtension on UserData {
  bool get hasDescriptionTranslation => descriptionTranslation != null;

  bool get hasConnections => connections != null;

  bool get following =>
      connections != null && connections!.contains('following');

  bool get follows =>
      connections != null && connections!.contains('followed_by');

  bool get hasDescription => description != null && description!.isNotEmpty;

  bool get hasUrl => userUrl != null;

  bool get hasLocation => location != null && location!.isNotEmpty;

  bool get hasCreatedAt => createdAt != null;

  bool get hasBanner => profileBannerUrl != null;

  String get appropriateUserImageUrl =>
      profileImageUrl!.replaceFirst('_normal', '_bigger');

  String get originalUserImageUrl => profileImageUrl!.replaceAll('_normal', '');

  String get appropriateUserBannerUrl {
    return '$profileBannerUrl/web_retina';
  }
}

EntitiesData userDescriptionEntities(
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
      hashtags: const [],
      media: const [],
      urls: userDescriptionUrls,
      userMentions: const [],
    );
  }
}
