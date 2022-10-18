import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final userProvider = StateNotifierProvider.autoDispose
    .family<UserNotifier, AsyncValue<UserData>, String>(
  (ref, handle) => UserNotifier(
    ref: ref,
    handle: handle,
    languagePreferences: ref.watch(languagePreferencesProvider),
    translateService: ref.watch(translateServiceProvider),
    twitterApi: ref.watch(twitterApiProvider),
  ),
  name: 'UserProvider',
);

class UserNotifier extends StateNotifier<AsyncValue<UserData>>
    with LoggerMixin {
  UserNotifier({
    required Ref ref,
    required String handle,
    required LanguagePreferences languagePreferences,
    required TranslateService translateService,
    required TwitterApi twitterApi,
  })  : _ref = ref,
        _handle = handle,
        _languagePreferences = languagePreferences,
        _translateService = translateService,
        _twitterApi = twitterApi,
        super(const AsyncValue.loading());

  final Ref _ref;
  final String _handle;
  final LanguagePreferences _languagePreferences;
  final TranslateService _translateService;
  final TwitterApi _twitterApi;

  Future<void> load([UserData? user]) async {
    if (user != null) {
      log.fine('using initialized user $user');
      state = AsyncData(user);
    } else {
      log.fine('loading user $user');
      state = await AsyncValue.guard(
        () => _twitterApi.userService
            .usersShow(screenName: _handle)
            .then(UserData.fromUser),
      );
    }
  }

  Future<void> translateDescription({
    required Locale locale,
  }) async {
    state.whenData((user) async {
      log.fine('translating user description');

      final translateLanguage =
          _languagePreferences.activeTranslateLanguage(locale);

      state = AsyncData(user.copyWith(isTranslatingDescription: true));

      final translation = await _translateService
          .translate(text: user.description ?? '', to: translateLanguage)
          .handleError(logErrorHandler);

      if (!mounted) return;

      if (translation != null && !translation.isTranslated) {
        _ref
            .read(messageServiceProvider)
            .showText('description not translated');
      }

      state = AsyncData(
        user.copyWith(
          isTranslatingDescription: false,
          descriptionTranslation: translation,
        ),
      );
    });
  }
}
