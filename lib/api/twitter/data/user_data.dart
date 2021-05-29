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
    this.profileBannerUrl,
    this.profileImageUrl,
    this.createdAt,
    this.location,
    this.entities,
    this.description,
    this.descriptionTranslation,
    this.connections,
  });

  /// Parses the [UserData] from the [TwitterApi] returned [User] object.
  factory UserData.fromUser(User? user) {
    final userDescriptionEntities = _userDescriptionEntities(
      user?.entities,
      user?.description,
    );

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
      entities: user?.entities,
      description: user?.description,
      // custom
      connections: const [],
      userDescriptionEntities: userDescriptionEntities,
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
  final UserEntities? entities;
  final String? description;

  // custom fields

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
    UserEntities? entities,
    String? description,
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
      entities: entities ?? this.entities,
      description: description ?? this.description,
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
        entities,
        description,
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

  bool get hasUrl =>
      entities?.url?.urls != null && entities!.url!.urls!.isNotEmpty;

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

EntitiesData _userDescriptionEntities(
  UserEntities? entities,
  String? description,
) {
  final urls = entities?.description?.urls ?? [];

  if (description != null) {
    final descriptionEntities = parseEntities(description);

    return descriptionEntities.copyWith(
      urls: urls.map((url) => UrlData.fromUrl(url)).toList(),
    );
  } else {
    return EntitiesData(
      hashtags: const [],
      media: const [],
      urls: urls.map((url) => UrlData.fromUrl(url)).toList(),
      userMentions: const [],
    );
  }
}
