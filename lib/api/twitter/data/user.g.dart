// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..name = json['name'] as String
    ..profileSidebarFillColor = json['profile_sidebar_fill_color'] as String
    ..profileBackgroundTitle = json['profile_background_title'] as bool
    ..profileImageUrl = json['profile_image_url'] as String
    ..createdAt = convertFromTwitterDateString(json['created_at'] as String)
    ..defaultProfile = json['default_profile'] as bool
    ..url = json['url'] as String
    ..contributorsEnabled = json['contributors_enabled'] as bool
    ..favouritesCount = json['favourites_count'] as int
    ..profileImageUrlHttps = json['profile_image_url_https'] as String
    ..id = json['id'] as int
    ..listedCount = json['listed_count'] as int
    ..profileUseBackgroundImage = json['profile_use_background_image'] as bool
    ..profileTextColor = json['profile_text_color'] as String
    ..followersCount = json['followers_count'] as int
    ..lang = json['lang'] as String
    ..protected = json['protected'] as bool
    ..geoEnabled = json['geo_enabled'] as bool
    ..notifications = json['notifications'] as bool
    ..description = json['description'] as String
    ..profileBackgroundColor = json['profile_background_color'] as String
    ..verified = json['verified'] as bool
    ..profileBackgroundImageUrlHttps =
        json['profile_background_image_url_https'] as String
    ..statusesCount = json['statuses_count'] as int
    ..profileBackgroundImageUrl = json['profile_background_image_url'] as String
    ..defaultProfileImage = json['default_profile_image'] as bool
    ..friendsCount = json['friends_count'] as int
    ..following = json['following'] as bool
    ..showAllInlineMedia = json['show_all_inline_media'] as bool
    ..screenName = json['screen_name'] as String
    ..entities = json['entities'] == null
        ? null
        : UserEntities.fromJson(json['entities'] as Map<String, dynamic>)
    ..profileBannerUrl = json['profile_banner_url'] as String
    ..location = json['location'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'profile_sidebar_fill_color': instance.profileSidebarFillColor,
      'profile_background_title': instance.profileBackgroundTitle,
      'profile_image_url': instance.profileImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'default_profile': instance.defaultProfile,
      'url': instance.url,
      'contributors_enabled': instance.contributorsEnabled,
      'favourites_count': instance.favouritesCount,
      'profile_image_url_https': instance.profileImageUrlHttps,
      'id': instance.id,
      'listed_count': instance.listedCount,
      'profile_use_background_image': instance.profileUseBackgroundImage,
      'profile_text_color': instance.profileTextColor,
      'followers_count': instance.followersCount,
      'lang': instance.lang,
      'protected': instance.protected,
      'geo_enabled': instance.geoEnabled,
      'notifications': instance.notifications,
      'description': instance.description,
      'profile_background_color': instance.profileBackgroundColor,
      'verified': instance.verified,
      'profile_background_image_url_https':
          instance.profileBackgroundImageUrlHttps,
      'statuses_count': instance.statusesCount,
      'profile_background_image_url': instance.profileBackgroundImageUrl,
      'default_profile_image': instance.defaultProfileImage,
      'friends_count': instance.friendsCount,
      'following': instance.following,
      'show_all_inline_media': instance.showAllInlineMedia,
      'screen_name': instance.screenName,
      'entities': instance.entities,
      'profile_banner_url': instance.profileBannerUrl,
      'location': instance.location,
    };
