// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['name'] as String,
      json['profile_sidebar_fill_color'] as String,
      json['profile_background_title'] as bool,
      json['profile_image_url'] as String,
      json['created_at'] as String,
      json['default_profile'] as bool,
      json['url'] as String,
      json['contributors_enabled'] as bool,
      json['favourites_count'] as int,
      json['profile_image_url_https'] as String,
      json['id'] as int,
      json['listed_count'] as int,
      json['profile_use_background_image'] as bool,
      json['profile_text_color'] as String,
      json['followers_count'] as int,
      json['lang'] as String,
      json['protected'] as bool,
      json['geo_enabled'] as bool,
      json['notifications'] as bool,
      json['description'] as String,
      json['profile_background_color'] as String,
      json['verified'] as bool,
      json['profile_background_image_url_https'] as String,
      json['statuses_count'] as int,
      json['profile_background_image_url'] as String,
      json['default_profile_image'] as bool,
      json['friends_count'] as int,
      json['following'] as bool,
      json['show_all_inline_media'] as bool,
      json['screen_name'] as String,
      json['entities'] == null
          ? null
          : UserEntities.fromJson(json['entities'] as Map<String, dynamic>),
      json['profile_banner_url'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'profile_sidebar_fill_color': instance.profileSidebarFillColor,
      'profile_background_title': instance.profileBackgroundTitle,
      'profile_image_url': instance.profileImageUrl,
      'created_at': instance.createdAt,
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
      'profile_background_color': instance.profileBackground_Color,
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
      'profile_banner_url': instance.profile_banner_url
    };
