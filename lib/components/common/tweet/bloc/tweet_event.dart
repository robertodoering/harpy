part of 'tweet_bloc.dart';

abstract class TweetEvent {
  const TweetEvent();

  Future<void> handle(TweetBloc bloc, Emitter emit);
}

class RetweetTweet extends TweetEvent with HarpyLogger {
  const RetweetTweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.isRetweeting) {
      log.fine('currently un-retweeting');
      bloc.tweet.retweeted = true;
      return;
    }

    bloc.tweet
      ..retweetCount += 1
      ..retweeted = true;

    emit(bloc.state.copyWith(isRetweeting: true));

    try {
      await app<TwitterApi>().tweetService.retweet(id: bloc.tweet.id);

      log.fine('retweeted ${bloc.tweet.id}');

      emit(bloc.state.copyWith(isRetweeting: false));

      if (!bloc.tweet.retweeted) {
        // the user has un-retweeted the tweet while we were making the request
        bloc.add(const UnretweetTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        bloc.tweet
          ..retweetCount = math.max(0, bloc.tweet.retweetCount - 1)
          ..retweeted = false;

        emit(bloc.state.copyWith(isRetweeting: false));

        log.warning('error retweeting ${bloc.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        emit(bloc.state.copyWith(isRetweeting: false));
      }
    }
  }
}

class UnretweetTweet extends TweetEvent with HarpyLogger {
  const UnretweetTweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.isRetweeting) {
      log.fine('currently retweeting');
      bloc.tweet.retweeted = false;
      return;
    }

    bloc.tweet
      ..retweetCount = math.max(0, bloc.tweet.retweetCount - 1)
      ..retweeted = false;

    emit(bloc.state.copyWith(isRetweeting: true));

    try {
      await app<TwitterApi>().tweetService.unretweet(id: bloc.tweet.id);

      log.fine('un-retweeted ${bloc.tweet.id}');

      emit(bloc.state.copyWith(isRetweeting: false));

      if (bloc.tweet.retweeted) {
        // the user has retweeted the tweet while we were making the request
        bloc.add(const RetweetTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        bloc.tweet
          ..retweetCount += 1
          ..retweeted = true;

        emit(bloc.state.copyWith(isRetweeting: false));

        log.warning('error un-retweeting ${bloc.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        emit(bloc.state.copyWith(isRetweeting: false));
      }
    }
  }
}

class FavoriteTweet extends TweetEvent with HarpyLogger {
  const FavoriteTweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.isFavoriting) {
      log.fine('currently un-favoriting');
      bloc.tweet.favorited = true;
      return;
    }

    bloc.tweet
      ..favoriteCount += 1
      ..favorited = true;

    emit(bloc.state.copyWith(isFavoriting: true));

    try {
      await app<TwitterApi>().tweetService.createFavorite(id: bloc.tweet.id);

      log.fine('favorited ${bloc.tweet.id}');

      emit(bloc.state.copyWith(isFavoriting: false));

      if (!bloc.tweet.favorited) {
        // the user has un-favorited the tweet while we were making the request
        bloc.add(const UnfavoriteTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        bloc.tweet
          ..favoriteCount = math.max(0, bloc.tweet.favoriteCount - 1)
          ..favorited = false;

        emit(bloc.state.copyWith(isFavoriting: false));

        log.warning('error favoriting ${bloc.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        emit(bloc.state.copyWith(isFavoriting: false));
      }
    }
  }
}

class UnfavoriteTweet extends TweetEvent with HarpyLogger {
  const UnfavoriteTweet();

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
    if (bloc.state.isFavoriting) {
      log.fine('currently favoriting');
      bloc.tweet.favorited = false;
      return;
    }

    bloc.tweet
      ..favoriteCount = math.max(0, bloc.tweet.favoriteCount - 1)
      ..favorited = false;

    emit(bloc.state.copyWith(isFavoriting: true));

    try {
      await app<TwitterApi>().tweetService.destroyFavorite(id: bloc.tweet.id);

      log.fine('un-favorited ${bloc.tweet.id}');

      emit(bloc.state.copyWith(isFavoriting: false));

      if (bloc.tweet.favorited) {
        // the user has favorited the tweet while we were making the request
        bloc.add(const FavoriteTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        bloc.tweet
          ..favoriteCount += 1
          ..favorited = true;

        emit(bloc.state.copyWith(isFavoriting: false));

        log.warning('error favoriting ${bloc.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        emit(bloc.state.copyWith(isFavoriting: false));
      }
    }
  }
}

class DeleteTweet extends TweetEvent with HarpyLogger {
  DeleteTweet({
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

class TranslateTweet extends TweetEvent {
  const TranslateTweet({
    required this.locale,
  });

  final Locale locale;

  @override
  Future<void> handle(TweetBloc bloc, Emitter emit) async {
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

    emit(bloc.state.copyWith(isTranslating: false));
  }
}

abstract class MediaActionEvent extends TweetEvent {
  const MediaActionEvent({
    required this.tweet,
    this.index,
  });

  /// The tweet that has the action for the media.
  // TODO: remove
  final TweetData tweet;

  /// When the tweet media is of type image, the index determines which image
  /// to select.
  final int? index;

  /// Returns the url of the selected media or `null` if no url exist.
  String? get mediaUrl {
    if (tweet.hasMedia) {
      if (tweet.hasImages) {
        return tweet.images![index ?? 0].baseUrl;
      } else if (tweet.gif != null) {
        return tweet.gif!.variants.first.url;
      } else if (tweet.video != null) {
        return tweet.video!.variants.first.url;
      }
    }

    return null;
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
