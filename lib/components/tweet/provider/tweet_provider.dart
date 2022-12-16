import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:rby/rby.dart';

final tweetProvider = StateNotifierProvider.autoDispose
    .family<TweetNotifier, LegacyTweetData?, String>(
  (ref, id) {
    ref.cacheFor(const Duration(minutes: 5));

    return TweetNotifier(
      ref: ref,
      twitterApi: ref.watch(twitterApiV1Provider),
      translateService: ref.watch(translateServiceProvider),
      messageService: ref.watch(messageServiceProvider),
      languagePreferences: ref.watch(languagePreferencesProvider),
    );
  },
);

class TweetNotifier extends StateNotifier<LegacyTweetData?> with LoggerMixin {
  TweetNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required TranslateService translateService,
    required MessageService messageService,
    required LanguagePreferences languagePreferences,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        _translateService = translateService,
        _messageService = messageService,
        _languagePreferences = languagePreferences,
        super(null);

  final Ref _ref;
  final TwitterApi _twitterApi;
  final TranslateService _translateService;
  final MessageService _messageService;
  final LanguagePreferences _languagePreferences;

  void initialize(LegacyTweetData tweet) {
    if (mounted && state == null) state = tweet;
  }

  Future<void> retweet() async {
    final tweet = state;
    if (tweet == null || tweet.retweeted) return;

    state = tweet.copyWith(
      retweeted: true,
      retweetCount: tweet.retweetCount + 1,
    );

    try {
      await _twitterApi.tweetService.retweet(id: tweet.id);

      log.fine('retweeted ${tweet.id}');
    } catch (e, st) {
      log.warning('error retweeting ${tweet.id}', e, st);

      state = tweet;

      twitterErrorHandler(_ref, e, st);
    }
  }

  Future<void> unretweet() async {
    final tweet = state;
    if (tweet == null || !tweet.retweeted) return;

    state = tweet.copyWith(
      retweeted: false,
      retweetCount: math.max(0, tweet.retweetCount - 1),
    );

    try {
      await _twitterApi.tweetService.unretweet(id: tweet.id);

      log.fine('un-retweeted ${tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error un-retweeting ${tweet.id}', e, st);

        state = tweet;

        twitterErrorHandler(_ref, e, st);
      }
    }
  }

  Future<void> favorite() async {
    final tweet = state;
    if (tweet == null || tweet.favorited) return;

    state = tweet.copyWith(
      favorited: true,
      favoriteCount: tweet.favoriteCount + 1,
    );

    try {
      await _twitterApi.tweetService.createFavorite(id: tweet.id);

      log.fine('favorited ${tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${tweet.id}', e, st);

        state = tweet;

        twitterErrorHandler(_ref, e, st);
      }
    }
  }

  Future<void> unfavorite() async {
    final tweet = state;
    if (tweet == null || !tweet.favorited) return;

    state = tweet.copyWith(
      favorited: false,
      favoriteCount: math.max(0, tweet.favoriteCount - 1),
    );

    try {
      await _twitterApi.tweetService.destroyFavorite(id: tweet.id);

      log.fine('un-favorited ${tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${tweet.id}', e, st);

        state = tweet;

        twitterErrorHandler(_ref, e, st);
      }
    }
  }

  Future<void> translate({
    required Locale locale,
  }) async {
    final tweet = state;
    if (tweet == null) return;

    final translateLanguage =
        _languagePreferences.activeTranslateLanguage(locale);

    final translatable = tweet.translatable(translateLanguage);

    if (tweet.quote != null && tweet.quote!.translatable(translateLanguage)) {
      // also translate quote if one exist
      _ref
          .read(tweetProvider(tweet.quote!.originalId).notifier)
          .translate(locale: locale)
          .ignore();
    }

    if (!translatable) {
      log.fine('tweet not translatable');
      return;
    }

    state = tweet.copyWith(isTranslating: true);

    final translation = await _translateService
        .translate(text: tweet.visibleText, to: translateLanguage)
        .handleError(logErrorHandler);

    if (translation != null && !translation.isTranslated) {
      _messageService.showText('tweet not translated');
    }

    state = tweet.copyWith(
      isTranslating: false,
      translation: translation,
    );
  }

  Future<void> delete({
    VoidCallback? onDeleted,
  }) async {
    final tweet = state;
    if (tweet == null) return;

    log.fine('deleting tweet');

    final result = await _twitterApi.tweetService
        .destroy(id: tweet.id, trimUser: true)
        .handleError((e, st) => twitterErrorHandler(_ref, e, st));

    if (result != null) {
      _messageService.showText('tweet deleted');
      onDeleted?.call();
    } else {
      _messageService.showText('error deleting tweet');
    }
  }
}

/// Returns `true` if the error contains any of the following error codes:
///
/// 139: already favorited
/// 327: already retweeted
/// 144: tweet with id not found (trying to unfavorite a tweet twice) or
/// trying to delete a tweet that has already been deleted before.
bool _actionPerformed(Object error) {
  if (error is Response) {
    try {
      final body = jsonDecode(error.body) as Map<String, dynamic>;
      final errors = body['errors'] as List<dynamic>?;

      return errors?.any(
            (error) =>
                error is Map<String, dynamic> &&
                (error['code'] == 139 ||
                    error['code'] == 327 ||
                    error['code'] == 144),
          ) ??
          false;
    } catch (e) {
      // ignore unexpected error format
    }
  }

  return false;
}
