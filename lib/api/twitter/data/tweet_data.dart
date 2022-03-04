import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'tweet_data.freezed.dart';

@freezed
class TweetData with _$TweetData {
  factory TweetData({
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

    /// The BCP 47 language identifier corresponding to the machine-detected
    /// language of the Tweet text, or `und` if no language could be detected.
    @Default('und') String lang,
    @Default(EntitiesData()) EntitiesData entities,

    // optional tweet fields

    /// The id of the tweet that this tweet is replying to.
    String? parentTweetId,

    /// The name and handle of the user that retweeted this tweet.
    ///
    /// `null` when this tweet is not a retweet.
    String? retweetUserName,
    String? retweetUserHandle,
    TweetData? quote,
    String? quoteUrl,

    // custom fields

    @Default(<TweetData>[]) List<TweetData> replies,

    /// The text of this tweet that the user can see.
    ///
    /// Does not contain optional media and quote links and the shortened urls
    /// are replaced with their display urls.
    @Default('') String visibleText,
    @Default(<MediaData>[]) List<MediaData> media,
    Translation? translation,

    /// Whether the tweet is currently being translated.
    @Default(false) bool isTranslating,
  }) = _TweetData;

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

    final mediaData = <MediaData>[];

    if (tweet.extendedEntities?.media?.isNotEmpty ?? false) {
      for (final media in tweet.extendedEntities!.media!) {
        if (media.type == kMediaPhoto) {
          mediaData.add(ImageMediaData.fromMedia(media));
        } else if (media.type == kMediaVideo || media.type == kMediaGif) {
          mediaData.add(VideoMediaData.fromMedia(media));
        }
      }
    }

    return TweetData(
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
      lang: tweet.lang ?? 'und',
      user: UserData.fromUser(tweet.user),
      entities: EntitiesData.fromEntities(tweet.entities),
      // optional
      parentTweetId: tweet.inReplyToStatusIdStr,
      retweetUserName: retweetUserName,
      retweetUserHandle: retweetUserHandle,
      quote: quote,
      quoteUrl: quoteUrl,
      // custom
      visibleText: _visibleText(tweet.fullText ?? '', quoteUrl, tweet.entities),
      media: mediaData,
    );
  }

  TweetData._();

  /// The [MediaType] for the media of this tweet or `null` if this tweet has no
  /// media.
  late final mediaType = media.isNotEmpty ? media[0].type : null;

  late final isRetweet = retweetUserName != null;
  late final hasImages = media.isNotEmpty && media[0].type == MediaType.image;
  late final hasSingleImage = media.length == 1 && hasImages;
  late final hasVideo = media.isNotEmpty && media[0].type == MediaType.video;
  late final hasGif = media.isNotEmpty && media[0].type == MediaType.gif;
  late final hasText = visibleText.isNotEmpty;
  late final hasParent = parentTweetId != null && parentTweetId!.isNotEmpty;
  late final tweetUrl = 'https://twitter.com/${user.handle}/status/$id';

  /// A concatenated string of the user names from the [replies].
  ///
  /// If [replies] is empty or the only reply author in [replies] is the same
  /// as the [user], an empty string is returned.
  // FIXME: we should limit the amount of authors that are displayed in the
  //  replies in case there are a lot
  late final replyAuthors = replies.fold<String>(
    '',
    (previousValue, reply) => previousValue.isNotEmpty
        ? '$previousValue, ${reply.user.name}'
        : reply.user.name,
  );

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
