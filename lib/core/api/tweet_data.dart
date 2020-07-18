import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/api/media_data.dart';
import 'package:harpy/core/api/user_data.dart';

/// The media types for [Media.type].
const String kMediaPhoto = 'photo';
const String kMediaVideo = 'video';
const String kMediaGif = 'animated_gif';

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

    if (tweet.extendedEntities?.media?.isNotEmpty == true) {
      for (Media media in tweet.extendedEntities.media) {
        if (media.type == kMediaPhoto) {
          images ??= <ImageData>[];
          images.add(ImageData.fromMedia(media));
        } else if (media.type == kMediaVideo) {
          video = VideoData.fromMedia(media);
        } else if (media.type == kMediaGif) {
          gif = VideoData.fromMedia(media);
        }
      }
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

  /// If this [TweetData] has quoted another tweet, the [quotedStatusUrl] is a
  /// shortened url of the quoted status.
  String quotedStatusUrl;

  /// A list of replies to this tweet.
  List<TweetData> replies = <TweetData>[];

  /// Contains up to 4 [ImageData] for the images of this tweet.
  ///
  /// When [images] is not `null`, no [video] or [gif] exists for this tweet.
  List<ImageData> images;

  /// The [VideoData] for the video of this tweet.
  ///
  /// When [video] is not `null`, no [images] or [gif] exists for this tweet.
  VideoData video;

  /// The [VideoData] for the gif of this tweet.
  ///
  /// When [gif] is not `null`, no [images] or [video] exists for this tweet.
  VideoData gif;

  /// Whether this is a retweet.
  bool get isRetweet => retweetUserName != null;

  /// Whether this tweet has text.
  bool get hasText => fullText?.isNotEmpty == true;

  /// Whether this tweet has quoted another tweet.
  bool get hasQuote => quote != null;

  /// Whether this tweet has up to 4 images, a video or a gif.
  bool get hasMedia =>
      images?.isNotEmpty == true || video != null || gif != null;
}
