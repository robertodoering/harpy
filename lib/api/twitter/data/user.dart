import 'package:harpy/api/twitter/data/user_entities.dart';
import 'package:harpy/core/utils/date_utils.dart';
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
  DateTime createdAt;
  @JsonKey(name: 'default_profile')
  bool defaultProfile;
  String url;
  @JsonKey(name: 'contributors_enabled')
  bool contributorsEnabled;
  @JsonKey(name: 'favourites_count')
  int favouritesCount;
  @JsonKey(name: 'profile_image_url_https')
  String profileImageUrlHttps;
  int id;
  @JsonKey(name: 'listed_count')
  int listedCount;
  @JsonKey(name: 'profile_use_background_image')
  bool profileUseBackgroundImage;
  @JsonKey(name: 'profile_text_color')
  String profileTextColor;
  @JsonKey(name: 'followers_count')
  int followersCount;
  String lang;
  bool protected;
  @JsonKey(name: 'geo_enabled')
  bool geoEnabled;
  bool notifications;
  String description;
  @JsonKey(name: 'profile_background_color')
  String profileBackgroundColor;
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
  bool following;
  @JsonKey(name: 'show_all_inline_media')
  bool showAllInlineMedia;
  @JsonKey(name: 'screen_name')
  String screenName;
  UserEntities entities;
  @JsonKey(name: 'profile_banner_url')
  String profileBannerUrl;
  String location;

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
    this.profileBackgroundColor,
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
    this.profileBannerUrl,
    this.location,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{name: $name, profileSidebarFillColor: $profileSidebarFillColor, profileBackgroundTitle: $profileBackgroundTitle, profileImageUrl: $profileImageUrl, createdAt: $createdAt, defaultProfile: $defaultProfile, url: $url, contributorsEnabled: $contributorsEnabled, favouritesCount: $favouritesCount, profileImageUrlHttps: $profileImageUrlHttps, id: $id, listedCount: $listedCount, profileUseBackgroundImage: $profileUseBackgroundImage, profileTextColor: $profileTextColor, followersCount: $followersCount, lang: $lang, protected: $protected, geoEnabled: $geoEnabled, notifications: $notifications, description: $description, profileBackground_Color: $profileBackgroundColor, verified: $verified, profileBackgroundImageUrlHttps: $profileBackgroundImageUrlHttps, statusesCount: $statusesCount, profileBackgroundImageUrl: $profileBackgroundImageUrl, defaultProfileImage: $defaultProfileImage, friendsCount: $friendsCount, following: $following, showAllInlineMedia: $showAllInlineMedia, screenName: $screenName}';
  }

  String getProfileImageUrlFromQuality(int quality) {
    switch (quality) {
      case 0:
        // original quality
        return profileImageUrlHttps.replaceFirst("_normal", "");
      case 1:
        // bigger
        return profileImageUrlHttps.replaceFirst("_normal", "_bigger");
      case 2:
      default:
        // normal
        return profileImageUrlHttps;
    }
  }
}
