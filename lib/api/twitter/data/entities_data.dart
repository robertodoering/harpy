import 'package:dart_twitter_api/twitter_api.dart' as v1;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'entities_data.freezed.dart';

@freezed
class EntitiesData with _$EntitiesData {
  const factory EntitiesData({
    @Default(<TagData>[]) List<TagData> hashtags,
    @Default(<TagData>[]) List<TagData> cashtags,
    @Default(<EntitiesMediaData>[]) List<EntitiesMediaData> media,
    @Default(<UrlData>[]) List<UrlData> urls,
    @Default(<UserMentionData>[]) List<UserMentionData> userMentions,
  }) = _EntitiesData;

  factory EntitiesData.fromV2UserDescriptionEntity(
    v2.UserDescriptionEntity userDescriptionEntity,
  ) {
    final hashtags = userDescriptionEntity.hashtags ?? [];
    final cashtags = userDescriptionEntity.cashtags ?? [];
    final mentions = userDescriptionEntity.mentions ?? [];
    final urls = userDescriptionEntity.urls ?? [];

    return EntitiesData(
      hashtags: hashtags.map(TagData.fromV2).toList(),
      cashtags: cashtags.map(TagData.fromV2).toList(),
      userMentions: mentions.map(UserMentionData.fromV2).toList(),
      urls: urls.map(UrlData.fromV2).toList(),
    );
  }

  factory EntitiesData.fromV2TweetEntities(
    v2.TweetEntities tweetEntities,
  ) {
    final hashtags = tweetEntities.hashtags ?? [];
    final cashtags = tweetEntities.cashtags ?? [];
    final mentions = tweetEntities.mentions ?? [];
    final urls = tweetEntities.urls ?? [];

    return EntitiesData(
      hashtags: hashtags.map(TagData.fromV2).toList(),
      cashtags: cashtags.map(TagData.fromV2).toList(),
      userMentions: mentions.map(UserMentionData.fromV2).toList(),
      urls: urls.map(UrlData.fromV2).toList(),
    );
  }

  factory EntitiesData.fromV1(v1.Entities? entities) {
    final hashtags = entities?.hashtags ?? [];
    final media = entities?.media ?? [];
    final urls = entities?.urls ?? [];
    final userMentions = entities?.userMentions ?? [];

    return EntitiesData(
      hashtags: hashtags.map(TagData.fromV1).toList(),
      media: media.map(EntitiesMediaData.fromV1).toList(),
      urls: urls.map(UrlData.fromV1).toList(),
      userMentions: userMentions.map(UserMentionData.fromV1).toList(),
    );
  }
}

@freezed
class TagData with _$TagData {
  const factory TagData({
    /// The text of the hastag or cashtag, minus any leading `#` or `$`.
    required String text,
  }) = _TagData;

  factory TagData.fromV2(v2.Tag tag) {
    return TagData(text: tag.tag);
  }

  factory TagData.fromV1(v1.Hashtag hashtag) {
    return TagData(
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

  factory EntitiesMediaData.fromV1(v1.Media media) {
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

  factory UrlData.fromV1(v1.Url url) {
    return UrlData(
      displayUrl: url.displayUrl ?? '',
      expandedUrl: url.expandedUrl ?? '',
      url: url.url ?? '',
    );
  }

  factory UrlData.fromV2(v2.Url url) {
    return UrlData(
      displayUrl: url.displayUrl,
      expandedUrl: url.expandedUrl,
      url: url.url,
    );
  }
}

@freezed
class UserMentionData with _$UserMentionData {
  const factory UserMentionData({
    /// The handle of the user, minus the leading `@` character.
    required String handle,
  }) = _UserMentionData;

  factory UserMentionData.fromV2(v2.Mention mention) {
    return UserMentionData(handle: mention.username);
  }

  factory UserMentionData.fromV1(v1.UserMention userMention) {
    return UserMentionData(
      handle: userMention.screenName ?? '',
    );
  }
}
