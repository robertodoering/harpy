import 'package:dart_twitter_api/twitter_api.dart';

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

    if (tweet.quotedStatus != null) {
      quote = TweetData.fromTweet(tweet.quotedStatus);
      quotedStatusUrl = tweet.quotedStatusPermalink?.url;
    }

    createdAt = tweet.createdAt;
    idStr = tweet.idStr;
    fullText = tweet.fullText;
    userData = UserData.fromUser(tweet.user);
    retweetCount = tweet.retweetCount;
    favoriteCount = tweet.favoriteCount;
    entities = tweet.entities;
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

  /// Entities which have been parsed out of the text of the Tweet.
  Entities entities;

  /// If this [TweetData] is a retweet, the [retweetUserName] is the name of the
  /// person that retweeted this tweet.
  ///
  /// `null` if this is not a retweet.
  String retweetUserName;

  /// This field only surfaces when the Tweet is a quote Tweet. This attribute
  /// contains the Tweet object of the original Tweet that was quoted.
  TweetData quote;

  /// Shortened url of the quoted status.
  String quotedStatusUrl;

  /// A list of replies to this tweet.
  List<TweetData> replies = <TweetData>[];

  /// Whether this is a retweet.
  bool get isRetweet => retweetUserName != null;

  /// Whether this tweet has text.
  bool get hasText => fullText?.isNotEmpty == true;

  /// Whether this tweet has quoted another tweet.
  bool get hasQuote => quote != null;
}

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
