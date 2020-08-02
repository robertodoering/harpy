import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/api/media_data.dart';
import 'package:harpy/core/api/translate/data/translation.dart';
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
    if (tweet == null) {
      return;
    }

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
    retweeted = tweet.retweeted;
    favorited = tweet.favorited;
    lang = tweet.lang;
    hasText = tweet.displayTextRange?.elementAt(0) != 0 ||
        tweet.displayTextRange?.elementAt(1) != 0;
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

  /// Whether this tweet has any display text.
  ///
  /// Display text is the user typed text. Entities such as a media link may be
  /// added to the [fullText] for this tweet.
  set hasText(bool hasText) => _hasText = hasText;
  bool _hasText;
  bool get hasText => _hasText != false;

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

  /// Indicates whether this Tweet has been liked by the authenticating user.
  bool favorited;

  /// Indicates whether this Tweet has been Retweeted by the authenticating
  /// user.
  bool retweeted;

  /// Indicates a BCP 47 language identifier corresponding to the
  /// machine-detected language of the Tweet text, or `und` if no language could
  /// be detected.
  String lang;

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

  /// The translation for this [TweetData].
  Translation translation;

  /// Cached [replyAuthors].
  String _replyAuthors;

  /// Finds and returns the display names of the authors that replied to this
  /// tweet.
  ///
  /// If the only reply author is the author of this tweet, an empty string is
  /// returned instead.
  ///
  /// After getting the reply authors once, the value is cached in
  /// [_replyAuthors].
  String get replyAuthors {
    if (_replyAuthors != null) {
      return _replyAuthors;
    }

    final Set<String> replyNames = <String>{};

    for (TweetData reply in replies) {
      replyNames.add(reply.userData.name);
    }

    if (replyNames.isEmpty ||
        replyNames.length == 1 && replyNames.first == userData.name) {
      return _replyAuthors = '';
    } else {
      return _replyAuthors = replyNames.join(', ');
    }
  }

  /// Whether this is a retweet.
  bool get isRetweet => retweetUserName != null;

  /// Whether this tweet has quoted another tweet.
  bool get hasQuote => quote != null;

  /// Whether this tweet has up to 4 images, a video or a gif.
  bool get hasMedia =>
      images?.isNotEmpty == true || video != null || gif != null;

  /// Wether this tweet has a translation.
  bool get hasTranslation => translation != null || quote?.translation != null;

  /// Whether this tweet can be translated.
  bool get translatable => hasText && lang != 'en';

  /// Wether the quote of this tweet can be translated, if one exists.
  bool get quoteTranslatable => quote?.translatable == true;
}
