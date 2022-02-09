import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entities_data.freezed.dart';

@freezed
class EntitiesData with _$EntitiesData {
  const factory EntitiesData({
    @Default(<HashtagData>[]) List<HashtagData> hashtags,
    @Default(<EntitiesMediaData>[]) List<EntitiesMediaData> media,
    @Default(<UrlData>[]) List<UrlData> urls,
    @Default(<UserMentionData>[]) List<UserMentionData> userMentions,
  }) = _EntitiesData;

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
}

@freezed
class HashtagData with _$HashtagData {
  const factory HashtagData({
    /// Name of the hashtag, minus the leading `#` character.
    required String text,
  }) = _HashtagData;

  factory HashtagData.fromHashtag(Hashtag hashtag) {
    return HashtagData(
      text: hashtag.text ?? '',
    );
  }
}

@freezed
class EntitiesMediaData with _$EntitiesMediaData {
  const factory EntitiesMediaData({
    /// Wrapped Url for the media link, corresponding to the value embedded
    /// directly into the raw tweet text.
    required String url,
  }) = _EntitiesMediaData;

  factory EntitiesMediaData.fromMedia(Media media) {
    return EntitiesMediaData(
      url: media.url ?? '',
    );
  }
}

@freezed
class UrlData with _$UrlData {
  const factory UrlData({
    /// Url pasted/typed into the tweet.
    ///
    /// Example: 'bit.ly/2so49n2'
    required String displayUrl,

    /// Expanded version of [displayUrl].
    ///
    /// Example: 'http://bit.ly/2so49n2'
    required String expandedUrl,

    /// Wrapped Url, corresponding to the value embedded directly into the raw
    /// tweet text.
    required String url,
  }) = _UrlData;

  factory UrlData.fromUrl(Url url) {
    return UrlData(
      displayUrl: url.displayUrl ?? '',
      expandedUrl: url.expandedUrl ?? '',
      url: url.url ?? '',
    );
  }
}

@freezed
class UserMentionData with _$UserMentionData {
  const factory UserMentionData({
    /// The handle of the user, minus the leading `@` character.
    required String handle,
  }) = _UserMentionData;

  factory UserMentionData.fromUserMention(UserMention userMention) {
    return UserMentionData(
      handle: userMention.screenName ?? '',
    );
  }
}
