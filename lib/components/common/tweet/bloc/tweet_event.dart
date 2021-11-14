part of 'tweet_bloc.dart';

abstract class TweetEvent {
  const TweetEvent();

  const factory TweetEvent.retweet() = _Retweet;
  const factory TweetEvent.unretweet() = _Unretweet;
  const factory TweetEvent.favorite() = _Favorite;
  const factory TweetEvent.unfavorite() = _Unfavorite;
  const factory TweetEvent.translate({required Locale locale}) = _Translate;
  const factory TweetEvent.delete({VoidCallback? onDeleted}) = _Delete;

  Future<void> handle(TweetBloc bloc, Emitter emit);
}

class _Retweet extends TweetEvent with HarpyLogger {
  const _Retweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.retweeted) {
      log.fine('already retweeted');
      return;
    }

    bloc.tweet
      ..retweetCount += 1
      ..retweeted = true;

    emit(bloc.state.copyWith(retweeted: true));

    try {
      await app<TwitterApi>().tweetService.retweet(id: bloc.tweet.id);

      log.fine('retweeted ${bloc.tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error retweeting ${bloc.tweet.id}', e, st);

        bloc.tweet
          ..retweetCount = math.max(0, bloc.tweet.retweetCount - 1)
          ..retweeted = false;

        emit(bloc.state.copyWith(retweeted: false));

        twitterApiErrorHandler(e);
      }
    }
  }
}

class _Unretweet extends TweetEvent with HarpyLogger {
  const _Unretweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (!bloc.state.retweeted) {
      log.fine('already not retweeted');
      return;
    }

    bloc.tweet
      ..retweetCount = math.max(0, bloc.tweet.retweetCount - 1)
      ..retweeted = false;

    emit(bloc.state.copyWith(retweeted: false));

    try {
      await app<TwitterApi>().tweetService.unretweet(id: bloc.tweet.id);

      log.fine('un-retweeted ${bloc.tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error un-retweeting ${bloc.tweet.id}', e, st);

        bloc.tweet
          ..retweetCount += 1
          ..retweeted = true;

        emit(bloc.state.copyWith(retweeted: true));

        twitterApiErrorHandler(e);
      }
    }
  }
}

class _Favorite extends TweetEvent with HarpyLogger {
  const _Favorite();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.favorited) {
      log.fine('already favorited');
      return;
    }

    bloc.tweet
      ..favoriteCount += 1
      ..favorited = true;

    emit(bloc.state.copyWith(favorited: true));

    try {
      await app<TwitterApi>().tweetService.createFavorite(id: bloc.tweet.id);

      log.fine('favorited ${bloc.tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${bloc.tweet.id}', e, st);

        bloc.tweet
          ..favoriteCount = math.max(0, bloc.tweet.favoriteCount - 1)
          ..favorited = false;

        emit(bloc.state.copyWith(favorited: false));

        twitterApiErrorHandler(e);
      }
    }
  }
}

class _Unfavorite extends TweetEvent with HarpyLogger {
  const _Unfavorite();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (!bloc.state.favorited) {
      log.fine('already not favorited');
      return;
    }

    bloc.tweet
      ..favoriteCount = math.max(0, bloc.tweet.favoriteCount - 1)
      ..favorited = false;

    emit(bloc.state.copyWith(favorited: false));

    try {
      await app<TwitterApi>().tweetService.destroyFavorite(id: bloc.tweet.id);

      log.fine('un-favorited ${bloc.tweet.id}');
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        log.warning('error favoriting ${bloc.tweet.id}', e, st);

        bloc.tweet
          ..favoriteCount += 1
          ..favorited = true;

        emit(bloc.state.copyWith(favorited: true));

        twitterApiErrorHandler(e);
      }
    }
  }
}

class _Translate extends TweetEvent with HarpyLogger {
  const _Translate({
    required this.locale,
  });

  final Locale locale;

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    log.fine('translating tweet');

    emit(bloc.state.copyWith(isTranslating: true));

    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    final translatable = bloc.tweet.translatable(translateLanguage);

    Translation? translation;

    if (translatable) {
      translation = await app<TranslationService>()
          .translate(text: bloc.tweet.visibleText, to: translateLanguage)
          .handleError(silentErrorHandler);
    }

    if (translatable && translation != null && translation.unchanged) {
      app<MessageService>().show('tweet not translated');
    }

    bloc.tweet.translation = translation;

    emit(
      bloc.state.copyWith(
        isTranslating: false,
        translated: bloc.tweet.hasTranslation,
      ),
    );
  }
}

class _Delete extends TweetEvent with HarpyLogger {
  const _Delete({
    this.onDeleted,
  });

  final VoidCallback? onDeleted;

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    log.fine('deleting tweet');

    final tweet = await app<TwitterApi>()
        .tweetService
        .destroy(id: bloc.tweet.id, trimUser: true)
        .handleError(silentErrorHandler);

    if (tweet != null) {
      app<MessageService>().show('tweet deleted');
      onDeleted?.call();
    } else {
      app<MessageService>().show('error deleting tweet');
    }
  }
}

/// Returns `true` if the error contains any of the following error codes:
///
/// 139: already favorited (trying to favorite a tweet twice)
/// 327: already retweeted
/// 144: tweet with id not found (trying to unfavorite a tweet twice) or
/// trying to delete a tweet that has already been deleted before.
bool _actionPerformed(dynamic error) {
  if (error is Response) {
    try {
      final Map<String, dynamic> body = jsonDecode(error.body);
      final List<dynamic> errors = body['errors'] ?? <Map<String, dynamic>>[];

      return errors.any(
        (dynamic error) =>
            error is Map<String, dynamic> &&
            (error['code'] == 139 ||
                error['code'] == 327 ||
                error['code'] == 144),
      );
    } catch (e) {
      // unexpected error format
    }
  }

  return false;
}
