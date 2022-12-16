import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'legacy_tweet_data.freezed.dart';

@freezed
class LegacyTweetData with _$LegacyTweetData {
  factory LegacyTweetData({
    required DateTime createdAt,
    required UserData user,

    /// The original id of this tweet.
    ///
    /// Differs from [id] when this tweet is a retweet.
    @Default('') String originalId,

    /// The id of this tweet.
    @Default('') String id,
    @Default('') String text,
    @Default('') String source,
    @Default(0) int retweetCount,
    @Default(0) int favoriteCount,
    @Default(false) bool retweeted,
    @Default(false) bool favorited,
    @Default(false) bool possiblySensitive,

    /// The BCP 47 language identifier corresponding to the machine-detected
    /// language of the Tweet text, or `und` if no language could be detected.
    @Default('und') String lang,
    @Default(EntitiesData()) EntitiesData entities,

    // optional tweet fields

    /// The id of the tweet that this tweet is replying to.
    String? parentTweetId,

    /// The user that retweeted this tweet.
    ///
    /// `null` when this tweet is not a retweet.
    UserData? retweeter,
    LegacyTweetData? quote,
    String? quoteUrl,

    // custom fields

    @Default(<LegacyTweetData>[]) List<LegacyTweetData> replies,

    /// The text of this tweet that the user can see.
    ///
    /// Does not contain optional media and quote links and the shortened urls
    /// are replaced with their display urls.
    @Default('') String visibleText,

    /// The url to preview if a tweet contains a single url and no media.
    Uri? previewUrl,
    @Default(<MediaData>[]) List<MediaData> media,
    Translation? translation,

    /// Whether the tweet is currently being translated.
    @Default(false) bool isTranslating,
  }) = _TweetData;

  factory LegacyTweetData.fromTweet(Tweet tweet) {
    final originalId = tweet.idStr ?? '';

    UserData? retweeter;

    if (tweet.retweetedStatus != null && tweet.user != null) {
      retweeter = UserData.fromV1(tweet.user!);
      tweet = tweet.retweetedStatus!;
    }

    LegacyTweetData? quote;
    String? quoteUrl;

    if (tweet.quotedStatus != null) {
      quote = LegacyTweetData.fromTweet(tweet.quotedStatus!);
      quoteUrl = tweet.quotedStatusPermalink?.url;
    }

    final mediaData = <MediaData>[];

    if (tweet.extendedEntities?.media?.isNotEmpty ?? false) {
      for (final media in tweet.extendedEntities!.media!) {
        if (media.type == kMediaPhoto) {
          mediaData.add(ImageMediaData.fromV1(media));
        } else if (mediaData.isEmpty && media.type == kMediaVideo ||
            media.type == kMediaGif) {
          mediaData.add(VideoMediaData.fromV1(media));
          break;
        }
      }
    }

    Uri? previewUrl;

    final allUrls = tweet.entities?.urls;

    if (mediaData.isEmpty && allUrls != null && allUrls.isNotEmpty) {
      final urls = List.of(allUrls)..removeWhere((url) => url.url == quoteUrl);

      if (urls.length == 1) {
        final urlString = urls.single.expandedUrl;

        if (urlString != null) {
          final uri = Uri.parse(urlString);

          if (uri.host != 'youtu.be' && !uri.host.startsWith('youtube')) {
            previewUrl = uri;
          }
        }
      }
    }

    return LegacyTweetData(
      // required
      originalId: originalId,
      id: tweet.idStr ?? '',
      createdAt: tweet.createdAt ?? DateTime.now(),
      text: tweet.fullText ?? '',
      source: _parseSource(tweet.source),
      retweetCount: tweet.retweetCount ?? 0,
      favoriteCount: tweet.favoriteCount ?? 0,
      retweeted: tweet.retweeted ?? false,
      favorited: tweet.favorited ?? false,
      possiblySensitive: tweet.possiblySensitive ?? false,
      lang: tweet.lang ?? 'und',
      user: tweet.user != null
          ? UserData.fromV1(tweet.user!)
          : const UserData(id: '', name: '', handle: ''),
      entities: EntitiesData.fromV1(tweet.entities),
      // optional
      parentTweetId: tweet.inReplyToStatusIdStr,
      retweeter: retweeter,
      quote: quote,
      quoteUrl: quoteUrl,
      // custom
      visibleText: _visibleText(tweet.fullText ?? '', quoteUrl, tweet.entities),
      media: mediaData,
      previewUrl: previewUrl,
    );
  }

  factory LegacyTweetData.fromV2(v2.TweetData tweet, v2.UserData user) {
    var tweetData = LegacyTweetData.fromTweet(
      Tweet()
        ..createdAt = tweet.createdAt
        ..idStr = tweet.id
        ..text = tweet.text
        ..source = tweet.source
        ..truncated = false
        ..inReplyToUserIdStr = tweet.inReplyToUserId
        ..lang = tweet.lang?.code
        ..fullText = tweet.text
        ..favoriteCount = tweet.publicMetrics?.likeCount
        ..retweetCount = tweet.publicMetrics?.retweetCount
        ..user = (User()
          ..idStr = user.id
          ..name = user.name
          ..screenName = user.username
          ..profileImageUrlHttps = user.profileImageUrl),
    );

    if (tweet.entities != null) {
      tweetData = tweetData.copyWith(
        entities: EntitiesData.fromV2TweetEntities(tweet.entities!),
      );
    }

    return tweetData;
  }

  LegacyTweetData._();

  /// The [MediaType] for the media of this tweet or `null` if this tweet has no
  /// media.
  late final mediaType = media.isNotEmpty ? media[0].type : null;

  late final isRetweet = retweeter != null;
  late final hasImages = media.isNotEmpty && media[0].type == MediaType.image;
  late final hasSingleImage = media.length == 1 && hasImages;
  late final hasVideo = media.isNotEmpty && media[0].type == MediaType.video;
  late final hasGif = media.isNotEmpty && media[0].type == MediaType.gif;
  late final hasText = visibleText.isNotEmpty;
  late final hasParent = parentTweetId != null && parentTweetId!.isNotEmpty;
  late final tweetUrl = 'https://twitter.com/${user.handle}/status/$id';
  late final isRtlLanguage = rtlLanguageCodes.contains(lang);

  /// A concatenated string of the user names from the [replies].
  String get replyAuthors {
    final names = replies.map((reply) => reply.user.name).toSet();

    // return an empty string if the only replier is the author of this tweet
    if (setEquals(names, {user.name})) return '';

    final concatenated = names.take(5).fold<String>(
          '',
          (previousValue, name) =>
              previousValue.isNotEmpty ? '$previousValue, $name' : name,
        );

    return names.length > 5
        ? '$concatenated and ${names.length - 5} more'
        : concatenated;
  }

  bool translatable(String translateLanguage) =>
      hasText && lang != 'und' && !translateLanguage.startsWith(lang);

  bool quoteTranslatable(String translateLanguage) =>
      quote != null && quote!.translatable(translateLanguage);

  String? downloadMediaUrl([int index = 0]) {
    return media.isNotEmpty ? media[index].bestUrl : null;
  }
}

/// Returns the text that the user sees in a tweet card.
///
/// Optional media and quote links are removed and the shortened urls are
/// replaced with their display urls.
String _visibleText(String text, String? quoteUrl, Entities? entities) {
  var visibleText = text;

  // remove the quote url if it exists
  if (quoteUrl != null) visibleText = visibleText.replaceAll(quoteUrl, '');

  // remove the media url if it exists
  entities?.media?.forEach((media) {
    visibleText = visibleText.replaceAll(media.url ?? '', '');
  });

  // replace the shortened urls with the display urls
  entities?.urls?.forEach((url) {
    visibleText = visibleText.replaceAll(url.url ?? '', url.displayUrl ?? '');
  });

  return parseHtmlEntities(visibleText.trim());
}

/// Returns the source without the enclosing html tag.
String _parseSource(String? source) {
  if (source != null) {
    final match = htmlTagRegex.firstMatch(source);
    final group = match?.group(0);

    if (group != null) {
      return group;
    }
  }

  return '';
}
