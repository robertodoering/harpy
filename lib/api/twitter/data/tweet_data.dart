import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

@immutable
class TweetData extends Equatable {
  const TweetData({
    required this.originalId,
    required this.id,
    required this.createdAt,
    required this.text,
    required this.retweetCount,
    required this.favoriteCount,
    required this.retweeted,
    required this.favorited,
    required this.lang,
    required this.user,
    required this.entities,
    required this.visibleText,
    required this.replies,
    required this.replyAuthors,
    this.inReplyToStatusId,
    this.retweetUserName,
    this.retweetUserHandle,
    this.quote,
    this.quoteUrl,
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
          images ??= <ImageData>[];
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
      retweetCount: tweet.retweetCount ?? 0,
      favoriteCount: tweet.favoriteCount ?? 0,
      retweeted: tweet.retweeted ?? false,
      favorited: tweet.favorited ?? false,
      lang: tweet.lang ?? 'und',
      entities: EntitiesData.fromEntities(tweet.entities),
      // optional
      user: UserData.fromUser(tweet.user),
      inReplyToStatusId: tweet.inReplyToStatusIdStr,
      retweetUserName: retweetUserName,
      retweetUserHandle: retweetUserHandle,
      quote: quote,
      quoteUrl: quoteUrl,
      // custom
      replies: const [],
      replyAuthors: '',
      visibleText: _visibleText(tweet.fullText ?? '', quoteUrl, tweet.entities),
      images: images,
      video: video,
      gif: gif,
    );
  }

  // required tweet fields

  final String originalId;
  final String id;
  final DateTime createdAt;
  final String text;
  final int retweetCount;
  final int favoriteCount;
  final bool retweeted;
  final bool favorited;
  final String lang;
  final UserData user;
  final EntitiesData entities;

  // optional tweet fields

  final String? inReplyToStatusId;

  final String? retweetUserName;
  final String? retweetUserHandle;

  final TweetData? quote;
  final String? quoteUrl;

  // custom fields

  final List<TweetData> replies;
  final String replyAuthors;

  final String visibleText;

  // todo: should just be one field 'media'
  final List<ImageData>? images;
  final VideoData? video;
  final VideoData? gif;

  final Translation? translation;

  TweetData copyWith({
    String? originalId,
    String? id,
    DateTime? createdAt,
    String? text,
    int? retweetCount,
    int? favoriteCount,
    bool? retweeted,
    bool? favorited,
    String? lang,
    UserData? user,
    EntitiesData? entities,
    String? inReplyToStatusId,
    String? retweetUserName,
    String? retweetUserHandle,
    TweetData? quote,
    String? quoteUrl,
    List<TweetData>? replies,
    String? visibleText,
    List<ImageData>? images,
    VideoData? video,
    VideoData? gif,
    Translation? translation,
  }) {
    return TweetData(
      originalId: originalId ?? this.originalId,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      retweetCount: retweetCount ?? this.retweetCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      retweeted: retweeted ?? this.retweeted,
      favorited: favorited ?? this.favorited,
      lang: lang ?? this.lang,
      user: user ?? this.user,
      entities: entities ?? this.entities,
      inReplyToStatusId: inReplyToStatusId ?? this.inReplyToStatusId,
      retweetUserName: retweetUserName ?? this.retweetUserName,
      retweetUserHandle: retweetUserHandle ?? this.retweetUserHandle,
      quote: quote ?? this.quote,
      quoteUrl: quoteUrl ?? this.quoteUrl,
      replies: replies ?? this.replies,
      replyAuthors: _replyAuthors(user ?? this.user, replies ?? this.replies),
      visibleText: visibleText ?? this.visibleText,
      images: images ?? this.images,
      video: video ?? this.video,
      gif: gif ?? this.gif,
      translation: translation ?? this.translation,
    );
  }

  @override
  List<Object?> get props => [
        originalId,
        id,
        createdAt,
        text,
        retweetCount,
        favoriteCount,
        retweeted,
        favorited,
        lang,
        user,
        entities,
        inReplyToStatusId,
        retweetUserName,
        retweetUserHandle,
        quote,
        quoteUrl,
        replies,
        replyAuthors,
        visibleText,
        images,
        video,
        gif,
        translation,
      ];
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

  bool get hasParent =>
      inReplyToStatusId != null && inReplyToStatusId!.isNotEmpty;

  /// Whether this tweet is the current reply parent in the reply screen.
  bool currentReplyParent(RouteSettings route) {
    if (route.name == RepliesScreen.route) {
      final arguments =
          route.arguments as Map<String, dynamic>? ?? <String, dynamic>{};

      return (arguments['tweet'] as TweetData?)?.id == id;
    } else {
      return false;
    }
  }

  /// The twitter url for this tweet.
  String get tweetUrl => 'https://twitter.com/${user.handle}/status/$id';
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

  return visibleText.trim();
}

/// Returns a concatenated string of the user names from the [replies].
///
/// If [replies] is empty or the only reply author in [replies] is the same
/// as the [user], an empty string is returned.
String _replyAuthors(UserData user, List<TweetData> replies) {
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
