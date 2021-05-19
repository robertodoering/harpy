import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Contains everything necessary to build a Tweet.
///
/// Allows for custom data to be stored compared to the Twitter returned [Tweet]
/// object.
class TweetData {
  TweetData.fromTweet(Tweet tweet) {
    originalIdStr = tweet.idStr ?? '';

    if (tweet.retweetedStatus != null && tweet.user != null) {
      retweetUserName = tweet.user!.name;
      retweetScreenName = tweet.user!.screenName;
      tweet = tweet.retweetedStatus!;
    }

    if (tweet.quotedStatus != null) {
      quote = TweetData.fromTweet(tweet.quotedStatus!);
      quotedStatusUrl = tweet.quotedStatusPermalink?.url;
    }

    if (tweet.extendedEntities?.media != null &&
        tweet.extendedEntities!.media!.isNotEmpty) {
      for (final media in tweet.extendedEntities!.media!) {
        if (media.type == kMediaPhoto) {
          images ??= <ImageData>[];
          images!.add(ImageData.fromMedia(media));
        } else if (media.type == kMediaVideo) {
          video = VideoData.fromMedia(media);
        } else if (media.type == kMediaGif) {
          gif = VideoData.fromMedia(media);
        }
      }
    }

    createdAt = tweet.createdAt;
    idStr = tweet.idStr ?? '';
    inReplyToStatusIdStr = tweet.inReplyToStatusIdStr ?? '';
    fullText = tweet.fullText;
    userData = tweet.user != null ? UserData.fromUser(tweet.user!) : null;
    retweetCount = tweet.retweetCount ?? 0;
    favoriteCount = tweet.favoriteCount ?? 0;
    entities = tweet.entities;
    retweeted = tweet.retweeted ?? false;
    favorited = tweet.favorited ?? false;
    lang = tweet.lang ?? 'und';
    hasText = visibleText.isNotEmpty;
  }

  /// UTC time when this Tweet was created.
  DateTime? createdAt;

  /// The string representation of the unique identifier for this Tweet.
  late String idStr;

  /// The string representation of the unique identifier for this Tweet.
  ///
  /// If this tweet is a retweet, this will be the id of the retweet while
  /// [idStr] is the id of the retweeted tweet.
  /// Otherwise this will be equal to [idStr].
  late String originalIdStr;

  /// If the represented Tweet is a reply, this field will contain the string
  /// representation of the original Tweet’s ID.
  String? inReplyToStatusIdStr;

  /// The actual UTF-8 text of the status update.
  String? fullText;

  /// The user who posted this Tweet.
  late UserData? userData;

  /// Number of times this Tweet has been retweeted.
  late int retweetCount;

  /// Indicates approximately how many times this Tweet has been liked by
  /// Twitter users.
  late int favoriteCount;

  /// Entities which have been parsed out of the text of the Tweet.
  Entities? entities;

  /// Whether this tweet has any display text.
  ///
  /// Display text is the user typed text. Entities such as a media link may be
  /// added to the [fullText] for this tweet.
  set hasText(bool hasText) => _hasText = hasText;
  bool? _hasText;
  bool get hasText => _hasText != null && _hasText!;

  /// If this [TweetData] is a retweet, the [retweetUserName] is the name of the
  /// person that retweeted this tweet.
  ///
  /// `null` if this is not a retweet.
  String? retweetUserName;

  /// If this [TweetData] is a retweet, the [retweetScreenName]
  /// is the screenName of the person that retweeted this tweet.
  ///
  /// `null` if this is not a retweet.
  String? retweetScreenName;

  /// This field only surfaces when the Tweet is a quote Tweet. This attribute
  /// contains the Tweet object of the original Tweet that was quoted.
  TweetData? quote;

  /// If this [TweetData] has quoted another tweet, the [quotedStatusUrl] is a
  /// shortened url of the quoted status.
  String? quotedStatusUrl;

  /// Indicates whether this Tweet has been liked by the authenticating user.
  late bool favorited;

  /// Indicates whether this Tweet has been Retweeted by the authenticating
  /// user.
  late bool retweeted;

  /// Indicates a BCP 47 language identifier corresponding to the
  /// machine-detected language of the Tweet text, or `und` if no language could
  /// be detected.
  late String lang;

  /// A list of replies to this tweet.
  List<TweetData> replies = <TweetData>[];

  /// Contains up to 4 [ImageData] for the images of this tweet.
  ///
  /// When [images] is not `null`, no [video] or [gif] exists for this tweet.
  List<ImageData>? images;

  /// The [VideoData] for the video of this tweet.
  ///
  /// When [video] is not `null`, no [images] or [gif] exists for this tweet.
  VideoData? video;

  /// The [VideoData] for the gif of this tweet.
  ///
  /// When [gif] is not `null`, no [images] or [video] exists for this tweet.
  VideoData? gif;

  /// The translation for this [TweetData].
  Translation? translation;

  /// Cached [replyAuthors].
  String? _replyAuthors;

  /// Finds and returns the display names of the authors that replied to this
  /// tweet.
  ///
  /// If the only reply author is the author of this tweet, an empty string is
  /// returned instead.
  ///
  /// After getting the reply authors once, the value is cached in
  /// [_replyAuthors].
  String? get replyAuthors {
    if (_replyAuthors != null) {
      return _replyAuthors;
    }

    final replyNames = <String?>{};

    for (final reply in replies) {
      replyNames.add(reply.userData!.name);
    }

    if (replyNames.isEmpty ||
        replyNames.length == 1 && replyNames.first == userData!.name) {
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
  bool get hasMedia => hasImages || hasVideo || hasGif;

  bool get hasImages => images != null && images!.isNotEmpty == true;
  bool get hasSingleImage => hasImages && images!.length == 1;
  bool get hasVideo => video != null;
  bool get hasGif => gif != null;

  /// Whether this tweet has a translation (translation may have been
  /// unsuccessful).
  bool get hasTranslation => translation != null || quote?.translation != null;

  /// Whether this tweet can be translated.
  ///
  /// Checks whether the twitter estimated tweet language is not 'und'
  /// (undefined) and not the target translation language (as set via the
  /// language preferences or the device language by default)
  bool translatable(String translateLanguage) =>
      hasText && lang != 'und' && !translateLanguage.startsWith(lang);

  /// Whether the quote of this tweet can be translated, if one exists.
  bool quoteTranslatable(String translateLanguage) =>
      quote != null && quote!.translatable(translateLanguage);

  /// Whether this tweet is a reply to another tweet.
  bool get hasParent =>
      inReplyToStatusIdStr != null && inReplyToStatusIdStr!.isNotEmpty;

  /// Whether this tweet is the current reply parent in the reply screen.
  bool currentReplyParent(RouteSettings route) {
    if (route.name == RepliesScreen.route) {
      final arguments =
          route.arguments as Map<String, dynamic>? ?? <String, dynamic>{};

      return (arguments['tweet'] as TweetData?)?.idStr == idStr;
    } else {
      return false;
    }
  }

  /// The twitter url for this tweet.
  String get tweetUrl =>
      'https://twitter.com/${userData!.screenName}/status/$idStr';

  /// Returns the [fullText] without the url to the quoted tweet or media and
  /// updates the shortened urls to the display url.
  String get visibleText {
    var visibleText = fullText ?? '';

    // remove url of quote if it exists
    if (quotedStatusUrl != null) {
      visibleText = visibleText.replaceAll(quotedStatusUrl!, '');
    }

    // remove url of media if it exists
    for (final media in entities?.media ?? <Media>[]) {
      visibleText = visibleText.replaceAll(media.url!, '');
    }

    // replace the shortened urls to the display urls
    for (final url in entities?.urls ?? <Url>[]) {
      visibleText = visibleText.replaceAll(url.url!, url.displayUrl!);
    }

    return visibleText.trim();
  }
}
