import 'package:harpy/api/twitter/data/user_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String name;
  @JsonKey(name: 'profile_sidebar_fill_color')
  String profileSidebarFillColor;
  @JsonKey(name: 'profile_background_title')
  bool profileBackgroundTitle;
  @JsonKey(name: 'profile_image_url')
  String profileImageUrl;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'default_profile')
  bool defaultProfile;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'contributors_enabled')
  bool contributorsEnabled;
  @JsonKey(name: 'favourites_count')
  int favouritesCount;
  @JsonKey(name: 'profile_image_url_https')
  String profileImageUrlHttps;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'listed_count')
  int listedCount;
  @JsonKey(name: 'profile_use_background_image')
  bool profileUseBackgroundImage;
  @JsonKey(name: 'profile_text_color')
  String profileTextColor;
  @JsonKey(name: 'followers_count')
  int followersCount;
  @JsonKey(name: 'lang')
  String lang;
  @JsonKey(name: 'protected')
  bool protected;
  @JsonKey(name: 'geo_enabled')
  bool geoEnabled;
  @JsonKey(name: 'notifications')
  bool notifications;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'profile_background_color')
  String profileBackground_Color;
  @JsonKey(name: 'verified')
  bool verified;
  @JsonKey(name: 'profile_background_image_url_https')
  String profileBackgroundImageUrlHttps;
  @JsonKey(name: 'statuses_count')
  int statusesCount;
  @JsonKey(name: 'profile_background_image_url')
  String profileBackgroundImageUrl;
  @JsonKey(name: 'default_profile_image')
  bool defaultProfileImage;
  @JsonKey(name: 'friends_count')
  int friendsCount;
  @JsonKey(name: 'following')
  bool following;
  @JsonKey(name: 'show_all_inline_media')
  bool showAllInlineMedia;
  @JsonKey(name: 'screen_name')
  String screenName;
  UserEntities entities;
  String profile_banner_url;

  User(
    this.name,
    this.profileSidebarFillColor,
    this.profileBackgroundTitle,
    this.profileImageUrl,
    this.createdAt,
    this.defaultProfile,
    this.url,
    this.contributorsEnabled,
    this.favouritesCount,
    this.profileImageUrlHttps,
    this.id,
    this.listedCount,
    this.profileUseBackgroundImage,
    this.profileTextColor,
    this.followersCount,
    this.lang,
    this.protected,
    this.geoEnabled,
    this.notifications,
    this.description,
    this.profileBackground_Color,
    this.verified,
    this.profileBackgroundImageUrlHttps,
    this.statusesCount,
    this.profileBackgroundImageUrl,
    this.defaultProfileImage,
    this.friendsCount,
    this.following,
    this.showAllInlineMedia,
    this.screenName,
    this.entities,
    this.profile_banner_url,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{name: $name, profileSidebarFillColor: $profileSidebarFillColor, profileBackgroundTitle: $profileBackgroundTitle, profileImageUrl: $profileImageUrl, createdAt: $createdAt, defaultProfile: $defaultProfile, url: $url, contributorsEnabled: $contributorsEnabled, favouritesCount: $favouritesCount, profileImageUrlHttps: $profileImageUrlHttps, id: $id, listedCount: $listedCount, profileUseBackgroundImage: $profileUseBackgroundImage, profileTextColor: $profileTextColor, followersCount: $followersCount, lang: $lang, protected: $protected, geoEnabled: $geoEnabled, notifications: $notifications, description: $description, profileBackground_Color: $profileBackground_Color, verified: $verified, profileBackgroundImageUrlHttps: $profileBackgroundImageUrlHttps, statusesCount: $statusesCount, profileBackgroundImageUrl: $profileBackgroundImageUrl, defaultProfileImage: $defaultProfileImage, friendsCount: $friendsCount, following: $following, showAllInlineMedia: $showAllInlineMedia, screenName: $screenName}';
  }

  String get userProfileImageOriginal =>
      profileImageUrlHttps.replaceFirst("_normal", "");

  String get userProfileImageBigger =>
      profileImageUrlHttps.replaceFirst("normal", "bigger");
}
