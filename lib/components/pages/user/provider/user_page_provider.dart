import 'package:dart_twitter_api/twitter_api.dart' as v1;
import 'package:flutter/widgets.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'user_page_provider.g.dart';

@riverpod
class UserPageNotifier extends _$UserPageNotifier {
  late AuthenticationState _auth;
  late LanguagePreferences _languagePreferences;
  late TranslateService _translateService;
  late v2.TwitterApi _twitterApiV2;

  @override
  Future<UserPageData> build(String handle) async {
    _auth = ref.watch(authenticationStateProvider);
    _languagePreferences = ref.watch(languagePreferencesProvider);
    _translateService = ref.watch(translateServiceProvider);
    _twitterApiV2 = ref.watch(twitterApiV2Provider);
    final twitterApiV1 = ref.watch(twitterApiV1Provider);

    final responses = await Future.wait([
      twitterApiV1.userService.usersShow(screenName: handle),
      // _twitterApiV2.users.lookupByName(
      //   username: handle,
      //   userFields: [
      //     v2.UserField.id,
      //     v2.UserField.description,
      //     v2.UserField.name,
      //     v2.UserField.username,
      //     v2.UserField.url,
      //     v2.UserField.profileImageUrl,
      //     v2.UserField.location,
      //     v2.UserField.pinnedTweetId,
      //     v2.UserField.protected,
      //     v2.UserField.verified,
      //     v2.UserField.publicMetrics,
      //     v2.UserField.entities,
      //     v2.UserField.createdAt,
      //     v2.UserField.withheld,
      //   ],
      //   tweetFields: [
      //     v2.TweetField.id,
      //     v2.TweetField.text,
      //     v2.TweetField.createdAt,
      //     v2.TweetField.entities,
      //     v2.TweetField.lang,
      //     v2.TweetField.publicMetrics,
      //   ],
      //   expansions: [v2.UserExpansion.pinnedTweetId],
      // ),
      twitterApiV1.userService
          .profileBanner(screenName: handle)
          .handleError(logErrorHandler),
      twitterApiV1.userService
          .friendshipsShow(sourceId: _auth.user?.id, targetScreenName: handle)
          .handleError(logErrorHandler),
    ]);

    final user = responses[0] as v1.User;
    // final user = responses[0] as v2.TwitterResponse<v2.UserData, void>;
    final banner = responses[1] as v1.Banner?;
    final relationship = responses[2] as v1.Relationship?;

    // final pinnedTweet = (user.includes?.tweets?.isNotEmpty ?? false)
    //     ? user.includes?.tweets?.first
    //     : null;

    return UserPageData(
      // user: UserData.fromV2(user.data),
      user: UserData.fromV1(user),
      bannerUrl: banner?.sizes?.size1500x500?.url,
      // pinnedTweet: pinnedTweet != null
      //     ? LegacyTweetData.fromV2(pinnedTweet, user.data)
      //     : null,
      relationship:
          relationship != null ? RelationshipData.fromV1(relationship) : null,
    );
  }

  Future<void> translateDescription({required Locale locale}) async {
    if (state is! AsyncData) return;
    final data = state.value!;

    if (data.descriptionTranslationState
        is! DescriptionTranslationStateUntranslated) return;

    final translateLanguage =
        _languagePreferences.activeTranslateLanguage(locale);

    state = AsyncData(
      data.copyWith(
        descriptionTranslationState:
            const DescriptionTranslationState.translating(),
      ),
    );

    final translation = await _translateService
        .translate(text: data.user.description ?? '', to: translateLanguage)
        .handleError(logErrorHandler);

    final translationState = translation != null && translation.isTranslated
        ? DescriptionTranslationState.translated(translation: translation)
        : const DescriptionTranslationState.notTranslated();

    if (translationState is DescriptionTranslationStateNotTranslated) {
      ref.read(messageServiceProvider).showText('description not translated');
    }

    state = AsyncData(
      state.value!.copyWith(
        descriptionTranslationState: translationState,
      ),
    );
  }

  Future<void> follow() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    state = state.copyWithRelationshipField(
      following: data.user.isProtected ? null : true,
      followingRequested: data.user.isProtected ? true : null,
    );

    await _twitterApiV2.users
        .createFollow(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still not following
        state = state.copyWithRelationshipField(
          following: data.user.isProtected ? null : false,
          followingRequested: data.user.isProtected ? false : null,
        );
      },
    );
  }

  Future<void> unfollow() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    final oldRelationship = data.relationship!;

    state = state.copyWithRelationshipField(
      following: false,
      followingRequested: false,
    );

    await _twitterApiV2.users
        .destroyFollow(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still following
        state = state.copyWithRelationshipField(
          following: oldRelationship.following,
          followingRequested: oldRelationship.followingRequested,
        );
      },
    );
  }

  // NOTE: blocking a user will automatically unfollow them
  Future<void> block() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    final oldRelationship = data.relationship!;

    state = state.copyWithRelationshipField(
      blocking: true,
      following: false,
      followingRequested: false,
    );

    await _twitterApiV2.users
        .createBlock(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still not blocking
        state = state.copyWithRelationshipField(
          blocking: false,
          following: oldRelationship.following,
          followingRequested: oldRelationship.followingRequested,
        );
      },
    );
  }

  Future<void> unblock() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    final oldRelationship = data.relationship!;

    state = state.copyWithRelationshipField(
      blocking: false,
      following: false,
      followingRequested: false,
    );

    await _twitterApiV2.users
        .destroyBlock(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still blocking
        state = state.copyWithRelationshipField(
          blocking: true,
          following: oldRelationship.following,
          followingRequested: oldRelationship.followingRequested,
        );
      },
    );
  }

  Future<void> mute() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    state = state.copyWithRelationshipField(muting: true);

    await _twitterApiV2.users
        .createMute(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still not muting
        state = state.copyWithRelationshipField(muting: false);
      },
    );
  }

  Future<void> unmute() async {
    final data = state.value;
    if (data == null) return;
    if (data.relationship == null) return;

    state = state.copyWithRelationshipField(muting: false);

    await _twitterApiV2.users
        .destroyMute(userId: _auth.user!.id, targetUserId: data.user.id)
        .handleError(
      (e, st) {
        twitterErrorHandler(ref, e, st);

        // assume still muting
        state = state.copyWithRelationshipField(muting: true);
      },
    );
  }
}

extension on AsyncValue<UserPageData> {
  AsyncData<UserPageData> copyWithRelationshipField({
    bool? following,
    bool? followingRequested,
    bool? muting,
    bool? blocking,
  }) {
    final relationship = asData!.value.relationship!;

    return AsyncData(
      asData!.value.copyWith(
        relationship: relationship.copyWith(
          following: following ?? relationship.following,
          followingRequested:
              followingRequested ?? relationship.followingRequested,
          muting: muting ?? relationship.muting,
          blocking: blocking ?? relationship.blocking,
        ),
      ),
    );
  }
}
