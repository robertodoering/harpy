import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// The user data for [TweetData].
class UserData {
  UserData.fromUser(User user) {
    idStr = user.idStr ?? '';
    name = user.name ?? '';
    screenName = user.screenName ?? '';
    location = user.location;
    entities = user.entities;
    description = user.description;
    verified = user.verified ?? false;
    followersCount = user.followersCount ?? 0;
    friendsCount = user.friendsCount ?? 0;
    createdAt = user.createdAt;
    profileBannerUrl = user.profileBannerUrl;
    profileImageUrlHttps = user.profileImageUrlHttps;
  }

  /// The string representation of the unique identifier for this User.
  late String idStr;

  /// The name of the user, as they’ve defined it. Not necessarily a person’s
  /// name. Typically capped at 50 characters, but subject to change.
  late String name;

  /// The screen name, handle, or alias that this user identifies themselves
  /// with. [screenName]s are unique but subject to change. Use id_str as a
  /// user identifier whenever possible. Typically a maximum of 15 characters
  /// long, but some historical accounts may exist with longer names.
  late String screenName;

  /// Nullable. The user-defined location for this account’s profile. Not
  /// necessarily a location, nor machine-parseable. This field will
  /// occasionally be fuzzily interpreted by the Search service.
  String? location;

  /// Entities for User Objects describe URLs that appear in the user defined
  /// profile URL and description fields.
  UserEntities? entities;

  /// Nullable. The user-defined UTF-8 string describing their account.
  String? description;

  /// When `true`, indicates that the user has a verified account.
  late bool verified;

  /// The number of followers this account currently has. Under certain
  /// conditions of duress, this field will temporarily indicate `0`.
  late int followersCount;

  /// The number of users this account is following (AKA their “followings”).
  /// Under certain conditions of duress, this field will temporarily indicate
  /// `0`.
  late int friendsCount;

  /// The UTC datetime that the user account was created on Twitter.
  DateTime? createdAt;

  /// The HTTPS-based URL pointing to the standard web representation of the
  /// user’s uploaded profile banner. By adding a final path element of the URL,
  /// it is possible to obtain different image sizes optimized for specific
  /// displays.
  ///
  /// See https://developer.twitter.com/en/docs/accounts-and-users/user-profile-images-and-banners
  /// for size variants.
  String? profileBannerUrl;

  /// A HTTPS-based URL pointing to the user’s profile image.
  String? profileImageUrlHttps;

  /// The connections for this relationship for the authenticated user.
  ///
  /// Can be: `following`, `following_requested`, `followed_by`, `none`,
  /// `blocking`, `muting`.
  ///
  /// Requested via [UserService.friendshipsLookup].
  List<String>? connections;

  /// The [Entities] used by the [TwitterText] for the user description.
  Entities? _userDescriptionEntities;
  Entities? get userDescriptionEntities {
    if (_userDescriptionEntities != null) {
      return _userDescriptionEntities;
    }

    _userDescriptionEntities = Entities()..urls = entities?.description?.urls;

    if (description != null) {
      parseEntities(description!, _userDescriptionEntities!);
    }

    return _userDescriptionEntities;
  }

  /// The translation for this [description].
  Translation? descriptionTranslation;

  /// Whether this user's description has been translated.
  bool get hasDescriptionTranslation => descriptionTranslation != null;

  /// Whether the relationship status for this user has been requested and the
  /// [Friendship.connections] set to [connections].
  bool get hasConnections => connections != null;

  /// Whether the authenticated user is following this user.
  ///
  /// Returns `false` if [connections] is `null`.
  bool get following => connections?.contains('following') == true;

  /// Whether this user follows the authenticated user.
  ///
  /// Returns `false` if [connections] is `null`.
  bool get follows => connections?.contains('followed_by') == true;

  /// Whether this user has a description.
  bool get hasDescription => description?.isNotEmpty == true;

  /// Whether this user has a url for their profile.
  bool get hasUrl => entities?.url?.urls?.isNotEmpty == true;

  /// Whether this user has a location set for their profile.
  bool get hasLocation => location?.isNotEmpty == true;

  /// Whether this user has a created at time.
  bool get hasCreatedAt => createdAt != null;

  /// Whether this user has a profile banner.
  bool get hasBanner => profileBannerUrl != null;

  /// The user profile image url for user images drawn in the app.
  ///
  /// See https://developer.twitter.com/en/docs/accounts-and-users/user-profile-images-and-banners.
  String get appropriateUserImageUrl =>
      profileImageUrlHttps!.replaceFirst('_normal', '_bigger');

  /// Returns the user profile image url in its original size.
  ///
  /// See https://developer.twitter.com/en/docs/accounts-and-users/user-profile-images-and-banners.
  String get originalUserImageUrl =>
      profileImageUrlHttps!.replaceAll('_normal', '');

  /// The user banner url for the user banner drawn in the app.
  ///
  /// See https://developer.twitter.com/en/docs/accounts-and-users/user-profile-images-and-banners.
  String get appropriateUserBannerUrl {
    return '$profileBannerUrl/web_retina';
  }
}
