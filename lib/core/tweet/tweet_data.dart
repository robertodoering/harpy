import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/api/users/data/user.dart';

/// Contains everything necessary to build a Tweet.
///
/// Uses less memory compared to the twitter API's [Tweet] object and allows for
/// custom data to be stored.
class TweetData {
  TweetData.fromTweet(Tweet tweet) {
    if (tweet.retweetedStatus != null) {
      retweetUserName = tweet.user.name;
      tweet = tweet.retweetedStatus;
    }

    createdAt = tweet.createdAt;
    idStr = tweet.idStr;
    fullText = tweet.fullText;
    userData = UserData.fromUser(tweet.user);
    retweetCount = tweet.retweetCount;
    favoriteCount = tweet.favoriteCount;
  }

  /// UTC time when this Tweet was created.
  DateTime createdAt;

  /// The string representation of the unique identifier for this Tweet.
  String idStr;

  /// The actual UTF-8 text of the status update.
  String fullText;

  /// The user who posted this Tweet.
  UserData userData;

  /// Number of times this Tweet has been retweeted.
  int retweetCount;

  /// Indicates approximately how many times this Tweet has been liked by
  /// Twitter users.
  int favoriteCount;

  /// If this [TweetData] is a retweet, the [retweetUserName] is the name of the
  /// person that retweeted this tweet.
  ///
  /// `null` if this is not a retweet.
  String retweetUserName;

  /// Whether this is a retweet.
  bool get isRetweet => retweetUserName != null;

  List<TweetData> replies = <TweetData>[];
}

/// The user data for [TweetData].
class UserData {
  UserData.fromUser(User user) {
    idStr = user.idStr;
    name = user.name;
    screenName = user.screenName;
    verified = user.verified;
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

  /// A HTTPS-based URL pointing to the user’s profile image.
  String profileImageUrlHttps;
}
