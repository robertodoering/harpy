import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/utils/string_utils.dart';

class TweetData {
  TweetData({
    required this.createdAt,
    required this.user,
    this.originalId = '',
    this.id = '',
    this.text = '',
    this.source = '',
    this.retweetCount = 0,
    this.favoriteCount = 0,
    this.retweeted = false,
    this.favorited = false,
    this.lang = 'und',
    this.entities = const EntitiesData(),
    this.parentTweetId,
    this.retweetUserName,
    this.retweetUserHandle,
    this.quote,
    this.quoteUrl,
    this.replies = const [],
    this.visibleText = '',
    this.images,
    this.video,
    this.gif,
    this.translation,
  });

  /// Parses the [TweetData] from the [TwitterApi] returned [Tweet] object.
  factory TweetData.fromTweet(Tweet tweet) {
    final originalId = tweet.idStr ?? '';

    String? retweetUserName;
    String? retweetUserHandle;

    if (tweet.retweetedStatus != null && tweet.user != null) {
      retweetUserName = tweet.user!.name;
      retweetUserHandle = tweet.user!.screenName;
      tweet = tweet.retweetedStatus!;
    }

    TweetData? quote;
    String? quoteUrl;

    if (tweet.quotedStatus != null) {
      quote = TweetData.fromTweet(tweet.quotedStatus!);
      quoteUrl = tweet.quotedStatusPermalink?.url;
    }

    List<ImageData>? images;
    VideoData? video;
    VideoData? gif;

    if (tweet.extendedEntities?.media != null &&
        tweet.extendedEntities!.media!.isNotEmpty) {
      for (final media in tweet.extendedEntities!.media!) {
        if (media.type == kMediaPhoto) {
          images ??= [];
          images.add(ImageData.fromMedia(media));
        } else if (media.type == kMediaVideo) {
          video = VideoData.fromMedia(media);
        } else if (media.type == kMediaGif) {
          gif = VideoData.fromMedia(media);
        }
      }
    }

    return TweetData(
      // required
      originalId: originalId,
      id: tweet.idStr ?? '',
      createdAt: tweet.createdAt ?? DateTime.now(),
      text: tweet.fullText ?? '',
      source: _source(tweet.source),
      retweetCount: tweet.retweetCount ?? 0,
      favoriteCount: tweet.favoriteCount ?? 0,
      retweeted: tweet.retweeted ?? false,
      favorited: tweet.favorited ?? false,
      lang: tweet.lang ?? 'und',
      entities: EntitiesData.fromEntities(tweet.entities),
      // optional
      user: UserData.fromUser(tweet.user),
      parentTweetId: tweet.inReplyToStatusIdStr,
      retweetUserName: retweetUserName,
      retweetUserHandle: retweetUserHandle,
      quote: quote,
      quoteUrl: quoteUrl,
      // custom
      visibleText: _visibleText(tweet.fullText ?? '', quoteUrl, tweet.entities),
      images: images,
      video: video,
      gif: gif,
    );
  }

  // required tweet fields

  /// The original id of this tweet.
  ///
  /// Differs from [id] when this tweet is a retweet.
  String originalId;

  /// The id of this tweet.
  String id;

  DateTime createdAt;
  String text;
  String source;
  int retweetCount;
  int favoriteCount;
  bool retweeted;
  bool favorited;

  /// The BCP 47 language identifier corresponding to the machine-detected
  /// language of the Tweet text, or `und` if no language could be detected.
  String lang;

  UserData user;
  EntitiesData entities;

  // optional tweet fields

  /// The id of the tweet that this tweet is replying to.
  String? parentTweetId;

  /// The name and handle of the user that retweeted this tweet.
  ///
  /// `null` when this tweet is not a retweet.
  String? retweetUserName;
  String? retweetUserHandle;
  TweetData? quote;
  String? quoteUrl;

  // custom fields

  List<TweetData> replies;

  /// The text of this tweet that the user can see.
  ///
  /// Does not contain optional media and quote links and the shortened urls are
  /// replaced with their display urls.
  String visibleText;

  // TODO: should just be one field 'media'
  List<ImageData>? images;
  VideoData? video;
  VideoData? gif;

  Translation? translation;
}

extension TweetDataExtension on TweetData {
  bool get isRetweet => retweetUserName != null;
  bool get hasQuote => quote != null;

  bool get hasMedia => hasImages || hasVideo || hasGif;
  bool get hasImages => images != null && images!.isNotEmpty == true;
  bool get hasSingleImage => hasImages && images!.length == 1;
  bool get hasVideo => video != null;
  bool get hasGif => gif != null;

  bool get hasTranslation => translation != null || quote?.translation != null;

  bool get hasText => visibleText.isNotEmpty;

  bool translatable(String translateLanguage) =>
      hasText && lang != 'und' && !translateLanguage.startsWith(lang);

  bool quoteTranslatable(String translateLanguage) =>
      quote != null && quote!.translatable(translateLanguage);

  bool get hasParent => parentTweetId != null && parentTweetId!.isNotEmpty;

  bool get hasSource => source.isNotEmpty;

  /// Whether this tweet is the current reply parent in the reply screen.
  bool currentReplyParent(BuildContext context) {
    final route = ModalRoute.of(context)?.settings;

    if (route != null && route.name == TweetDetailScreen.route) {
      if (route.arguments is Map<String, dynamic>) {
        final arguments = route.arguments as Map<String, dynamic>;

        if (arguments['tweet'] is TweetData) {
          return (arguments['tweet'] as TweetData).id == id;
        }
      }

      assert(false, 'tweet inside an invalid route');
    }

    return false;
  }

  String get tweetUrl => 'https://twitter.com/${user.handle}/status/$id';

  /// Returns the [MediaType] for the media of this tweet or `null` if this
  /// tweet has no media.
  MediaType? get mediaType {
    if (hasImages) {
      return MediaType.image;
    } else if (hasGif) {
      return MediaType.gif;
    } else if (hasVideo) {
      return MediaType.video;
    } else {
      return null;
    }
  }

  String? downloadMediaUrl([int index = 0]) {
    if (hasImages) {
      return images![index].bestUrl;
    } else if (hasGif) {
      return gif!.bestUrl;
    } else if (hasVideo) {
      return video!.bestUrl;
    }

    return null;
  }

  /// Returns a concatenated string of the user names from the [replies].
  ///
  /// If [replies] is empty or the only reply author in [replies] is the same
  /// as the [user], an empty string is returned.
  String get replyAuthors {
    final replyNames = <String>{};

    for (final reply in replies) {
      replyNames.add(reply.user.name);
    }

    if (replyNames.isEmpty ||
        replyNames.length == 1 && replyNames.first == user.name) {
      return '';
    } else {
      return replyNames.join(', ');
    }
  }
}

/// Returns the text that the user sees in a tweet card.
///
/// Optional media and quote links are removed and the shortened urls are
/// replaced with their display urls.
String _visibleText(
  String text,
  String? quoteUrl,
  Entities? entities,
) {
  var visibleText = text;

  // remove url of quote if it exists
  if (quoteUrl != null) {
    visibleText = visibleText.replaceAll(quoteUrl, '');
  }

  // remove url of media if it exists
  for (final media in entities?.media ?? <Media>[]) {
    visibleText = visibleText.replaceAll(media.url!, '');
  }

  // replace the shortened urls to the display urls
  for (final url in entities?.urls ?? <Url>[]) {
    visibleText = visibleText.replaceAll(url.url!, url.displayUrl!);
  }

  return parseHtmlEntities(visibleText.trim()) ?? '';
}

String _source(String? source) {
  if (source != null) {
    final match = htmlTagRegex.firstMatch(source);
    final group = match?.group(0);

    if (group != null) {
      return group;
    }
  }

  return '';
}
