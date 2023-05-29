import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';

part 'user_page_data.freezed.dart';

@freezed
class UserPageData with _$UserPageData {
  const factory UserPageData({
    required UserData user,
    String? bannerUrl,
    @Default(DescriptionTranslationState.untranslated())
    DescriptionTranslationState descriptionTranslationState,
    LegacyTweetData? pinnedTweet,
    RelationshipData? relationship,
  }) = _UserPageData;
}

@freezed
class DescriptionTranslationState with _$DescriptionTranslationState {
  const factory DescriptionTranslationState.untranslated() =
      DescriptionTranslationStateUntranslated;

  const factory DescriptionTranslationState.translating() =
      DescriptionTranslationStateTranslating;

  const factory DescriptionTranslationState.translated({
    required Translation translation,
  }) = DescriptionTranslationStateTranslated;

  const factory DescriptionTranslationState.notTranslated() =
      DescriptionTranslationStateNotTranslated;
}
