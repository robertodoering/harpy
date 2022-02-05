import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';

class EntitiesData extends Equatable {
  const EntitiesData({
    this.hashtags = const [],
    this.media = const [],
    this.urls = const [],
    this.userMentions = const [],
  });

  factory EntitiesData.fromEntities(Entities? entities) {
    final hashtags = entities?.hashtags ?? [];
    final media = entities?.media ?? [];
    final urls = entities?.urls ?? [];
    final userMentions = entities?.userMentions ?? [];

    return EntitiesData(
      hashtags: hashtags.map(HashtagData.fromHashtag).toList(),
      media: media.map(EntitiesMediaData.fromMedia).toList(),
      urls: urls.map(UrlData.fromUrl).toList(),
      userMentions: userMentions.map(UserMentionData.fromUserMention).toList(),
    );
  }

  final List<HashtagData> hashtags;
  final List<EntitiesMediaData> media;
  final List<UrlData> urls;
  final List<UserMentionData> userMentions;

  @override
  List<Object?> get props => [
        hashtags,
        media,
        urls,
        userMentions,
      ];

  EntitiesData copyWith({
    List<HashtagData>? hashtags,
    List<EntitiesMediaData>? media,
    List<UrlData>? urls,
    List<UserMentionData>? userMentions,
  }) {
    return EntitiesData(
      hashtags: hashtags ?? this.hashtags,
      media: media ?? this.media,
      urls: urls ?? this.urls,
      userMentions: userMentions ?? this.userMentions,
    );
  }
}

class HashtagData extends Equatable {
  const HashtagData({
    required this.text,
  });

  factory HashtagData.fromHashtag(Hashtag hashtag) {
    return HashtagData(
      text: hashtag.text ?? '',
    );
  }

  /// Name of the hashtag, minus the leading `#` character.
  final String text;

  @override
  List<Object?> get props => [
        text,
      ];
}

class EntitiesMediaData extends Equatable {
  const EntitiesMediaData({
    required this.url,
  });

  factory EntitiesMediaData.fromMedia(Media media) {
    return EntitiesMediaData(
      url: media.url ?? '',
    );
  }

  /// Wrapped Url for the media link, corresponding to the value embedded
  /// directly into the raw tweet text.
  final String url;

  @override
  List<Object?> get props => [
        url,
      ];
}

class UrlData extends Equatable {
  const UrlData({
    required this.displayUrl,
    required this.expandedUrl,
    required this.url,
  });

  factory UrlData.fromUrl(Url url) {
    return UrlData(
      displayUrl: url.displayUrl ?? '',
      expandedUrl: url.expandedUrl ?? '',
      url: url.url ?? '',
    );
  }

  /// Url pasted/typed into the tweet.
  ///
  /// Example: 'bit.ly/2so49n2'
  final String displayUrl;

  /// Expanded version of [displayUrl].
  ///
  /// Example: 'http://bit.ly/2so49n2'
  final String expandedUrl;

  /// Wrapped Url, corresponding to the value embedded directly into the raw
  /// tweet text.
  final String url;

  @override
  List<Object?> get props => [
        displayUrl,
        expandedUrl,
        url,
      ];
}

class UserMentionData extends Equatable {
  const UserMentionData({
    required this.handle,
  });

  factory UserMentionData.fromUserMention(UserMention userMention) {
    return UserMentionData(
      handle: userMention.screenName ?? '',
    );
  }

  /// The handle of the user, minus the leading `@` character.
  final String handle;

  @override
  List<Object?> get props => [
        handle,
      ];
}
