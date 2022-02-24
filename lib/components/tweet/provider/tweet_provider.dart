import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:http/http.dart';

final tweetProvider =
    StateNotifierProvider.family<TweetNotifier, TweetData, TweetData>(
  (ref, tweet) => TweetNotifier(
    read: ref.read,
    tweet: tweet,
    twitterApi: ref.watch(twitterApiProvider),
    translateService: ref.watch(translateServiceProvider),
    messageService: ref.watch(messageServiceProvider),
    languagePreferences: ref.watch(languagePreferencesProvider),
  ),
  name: 'TweetProvider',
);

class TweetNotifier extends StateNotifier<TweetData> with LoggerMixin {
  TweetNotifier({
    required Reader read,
    required TweetData tweet,
    required TwitterApi twitterApi,
    required TranslateService translateService,
    required MessageService messageService,
    required LanguagePreferences languagePreferences,
  })  : _read = read,
        _twitterApi = twitterApi,
        _translateService = translateService,
        _messageService = messageService,
        _languagePreferences = languagePreferences,
        super(tweet);

  final Reader _read;
  final TwitterApi _twitterApi;
  final TranslateService _translateService;
  final MessageService _messageService;
  final LanguagePreferences _languagePreferences;

  Future<void> retweet() async {
    if (state.retweeted) {
      log.fine('already retweeted');
      return;
    }

    state = state.copyWith(
      retweeted: true,
      retweetCount: state.retweetCount + 1,
    );

    try {
      await _twitterApi.tweetService.retweet(id: state.id);

      log.fine('retweeted ${state.id}');
    } catch (e, st) {
      log.warning('error retweeting ${state.id}', e, st);

      state = state.copyWith(
        retweeted: false,
        retweetCount: math.max(0, state.retweetCount - 1),
      );

      twitterErrorHandler(_read, e, st);
    }
  }

  Future<void> unretweet() async {
    if (!state.retweeted) {
      log.fine('already not retweeted');
      return;
    }

    state = state.copyWith(
      retweeted: false,
      retweetCount: math.max(0, state.retweetCount - 1),
    );

    try {
      await _twitterApi.tweetService.unretweet(id: state.id);

      log.fine('un-retweeted ${state.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error un-retweeting ${state.id}', e, st);

        state = state.copyWith(
          retweeted: true,
          retweetCount: state.retweetCount + 1,
        );

        twitterErrorHandler(_read, e, st);
      }
    }
  }

  Future<void> favorite() async {
    if (state.favorited) {
      log.fine('already favorited');
      return;
    }

    state = state.copyWith(
      favorited: true,
      favoriteCount: state.favoriteCount + 1,
    );

    try {
      await _twitterApi.tweetService.createFavorite(id: state.id);

      log.fine('favorited ${state.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${state.id}', e, st);

        state = state.copyWith(
          favorited: false,
          favoriteCount: math.max(0, state.favoriteCount - 1),
        );

        twitterErrorHandler(_read, e, st);
      }
    }
  }

  Future<void> unfavorite() async {
    if (!state.favorited) {
      log.fine('already not favorited');
      return;
    }

    state = state.copyWith(
      favorited: false,
      favoriteCount: math.max(0, state.favoriteCount - 1),
    );

    try {
      await _twitterApi.tweetService.destroyFavorite(id: state.id);

      log.fine('un-favorited ${state.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${state.id}', e, st);

        state = state.copyWith(
          favorited: true,
          favoriteCount: state.favoriteCount + 1,
        );

        twitterErrorHandler(_read, e, st);
      }
    }
  }

  Future<void> translate({
    required Locale locale,
  }) async {
    final translateLanguage =
        _languagePreferences.activeTranslateLanguage(locale);

    final translatable = state.translatable(translateLanguage);

    if (state.quote != null && state.quote!.translatable(translateLanguage)) {
      // also translate quote if one exist
      _read(tweetProvider(state.quote!).notifier)
          .translate(locale: locale)
          .ignore();
    }

    if (!translatable) {
      log.fine('tweet not translatable');
      return;
    }

    state = state.copyWith(isTranslating: true);

    final translation = await _translateService
        .translate(text: state.visibleText, to: translateLanguage)
        .handleError(logErrorHandler);

    if (translation != null && !translation.isTranslated) {
      _messageService.showText('tweet not translated');
    }

    state = state.copyWith(
      isTranslating: false,
      translation: translation,
    );
  }

  Future<void> delete({
    VoidCallback? onDeleted,
  }) async {
    log.fine('deleting tweet');

    final tweet = await _twitterApi.tweetService
        .destroy(id: state.id, trimUser: true)
        .handleError((dynamic e, st) => twitterErrorHandler(_read, e, st));

    if (tweet != null) {
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
bool _actionPerformed(dynamic error) {
  if (error is Response) {
    try {
      final Map<String, dynamic> body = jsonDecode(error.body);
      final List<dynamic>? errors = body['errors'];

      return errors?.any(
            (dynamic error) =>
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
