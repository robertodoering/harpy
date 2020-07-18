import 'package:dart_twitter_api/twitter_api.dart';

/// The user data for [TweetData].
class UserData {
  UserData.fromUser(User user) {
    idStr = user.idStr;
    name = user.name;
    screenName = user.screenName;
    verified = user.verified;
    followersCount = user.followersCount;
    friendsCount = user.friendsCount;
    profileImageUrlHttps = user.profileImageUrlHttps;
  }

  /// The string representation of the unique identifier for this User.
  String idStr;

  /// The name of the user, as they’ve defined it. Not necessarily a person’s
  /// name. Typically capped at 50 characters, but subject to change.
  String name;

  /// The screen name, handle, or alias that this user identifies themselves
  /// with. [screen_names] are unique but subject to change. Use id_str as a
  /// user identifier whenever possible. Typically a maximum of 15 characters
  /// long, but some historical accounts may exist with longer names.
  String screenName;

  /// When `true`, indicates that the user has a verified account.
  bool verified;

  /// The number of followers this account currently has. Under certain
  /// conditions of duress, this field will temporarily indicate `0`.
  int followersCount;

  /// The number of users this account is following (AKA their “followings”).
  /// Under certain conditions of duress, this field will temporarily indicate
  /// `0`.
  int friendsCount;

  /// A HTTPS-based URL pointing to the user’s profile image.
  String profileImageUrlHttps;
}
