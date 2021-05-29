part of 'tweet_bloc.dart';

@immutable
abstract class TweetEvent {
  const TweetEvent();

  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  });
}

class RetweetTweet extends TweetEvent with HarpyLogger {
  const RetweetTweet();

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    if (bloc.state.isRetweeting) {
      log.fine('currently un-retweeting');
      yield bloc.state.copyWith(
        tweet: bloc.state.tweet.copyWith(retweeted: true),
      );
      return;
    }

    yield bloc.state.copyWith(
      tweet: bloc.state.tweet.copyWith(
        retweetCount: bloc.state.tweet.retweetCount + 1,
        retweeted: true,
      ),
      isRetweeting: true,
    );

    try {
      await bloc.tweetService.retweet(id: bloc.state.tweet.id);

      log.fine('retweeted ${bloc.state.tweet.id}');

      yield bloc.state.copyWith(isRetweeting: false);

      if (!bloc.state.tweet.retweeted) {
        // the user has un-retweeted the tweet while we were making the request
        bloc.add(const UnretweetTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        yield bloc.state.copyWith(
          tweet: bloc.state.tweet.copyWith(
            retweetCount: math.max(0, bloc.state.tweet.retweetCount - 1),
            retweeted: false,
          ),
          isRetweeting: false,
        );

        log.warning('error retweeting ${bloc.state.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        yield bloc.state.copyWith(isRetweeting: false);
      }
    }
  }
}

class UnretweetTweet extends TweetEvent with HarpyLogger {
  const UnretweetTweet();

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    if (bloc.state.isRetweeting) {
      log.fine('currently retweeting');
      yield bloc.state.copyWith(
        tweet: bloc.state.tweet.copyWith(retweeted: false),
      );
      return;
    }

    yield bloc.state.copyWith(
      tweet: bloc.state.tweet.copyWith(
        retweetCount: math.max(0, bloc.state.tweet.retweetCount - 1),
        retweeted: false,
      ),
      isRetweeting: true,
    );

    try {
      await bloc.tweetService.unretweet(id: bloc.state.tweet.id);

      log.fine('un-retweeted ${bloc.state.tweet.id}');

      yield bloc.state.copyWith(isRetweeting: false);

      if (bloc.state.tweet.retweeted) {
        // the user has retweeted the tweet while we were making the request
        bloc.add(const RetweetTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        yield bloc.state.copyWith(
          tweet: bloc.state.tweet.copyWith(
            retweetCount: bloc.state.tweet.retweetCount + 1,
            retweeted: true,
          ),
          isRetweeting: false,
        );

        log.warning('error un-retweeting ${bloc.state.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        yield bloc.state.copyWith(isRetweeting: false);
      }
    }
  }
}

class FavoriteTweet extends TweetEvent with HarpyLogger {
  const FavoriteTweet();

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    if (bloc.state.isFavoriting) {
      log.fine('currently un-favoriting');
      yield bloc.state.copyWith(
        tweet: bloc.state.tweet.copyWith(favorited: true),
      );
      return;
    }

    yield bloc.state.copyWith(
      tweet: bloc.state.tweet.copyWith(
        favoriteCount: bloc.state.tweet.favoriteCount + 1,
        favorited: true,
      ),
      isFavoriting: true,
    );

    try {
      await bloc.tweetService.createFavorite(id: bloc.state.tweet.id);

      log.fine('favorited ${bloc.state.tweet.id}');

      yield bloc.state.copyWith(isFavoriting: false);

      if (!bloc.state.tweet.favorited) {
        // the user has un-favorited the tweet while we were making the request
        bloc.add(const UnfavoriteTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        yield bloc.state.copyWith(
          tweet: bloc.state.tweet.copyWith(
            favoriteCount: math.max(0, bloc.state.tweet.favoriteCount - 1),
            favorited: false,
          ),
          isFavoriting: false,
        );

        log.warning('error favoriting ${bloc.state.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        yield bloc.state.copyWith(isFavoriting: false);
      }
    }
  }
}

class UnfavoriteTweet extends TweetEvent with HarpyLogger {
  const UnfavoriteTweet();

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    if (bloc.state.isFavoriting) {
      log.fine('currently favoriting');
      yield bloc.state.copyWith(
        tweet: bloc.state.tweet.copyWith(favorited: false),
      );
      return;
    }

    yield bloc.state.copyWith(
      tweet: bloc.state.tweet.copyWith(
        favoriteCount: math.max(0, bloc.state.tweet.favoriteCount - 1),
        favorited: false,
      ),
      isFavoriting: true,
    );

    try {
      await bloc.tweetService.destroyFavorite(id: bloc.state.tweet.id);

      log.fine('un-favorited ${bloc.state.tweet.id}');

      yield bloc.state.copyWith(isFavoriting: false);

      if (bloc.state.tweet.favorited) {
        // the user has favorited the tweet while we were making the request
        bloc.add(const FavoriteTweet());
      }
    } catch (e, st) {
      if (!_actionPerformed(e)) {
        yield bloc.state.copyWith(
          tweet: bloc.state.tweet.copyWith(
            favoriteCount: bloc.state.tweet.favoriteCount + 1,
            favorited: true,
          ),
          isFavoriting: false,
        );

        log.warning('error favoriting ${bloc.state.tweet.id}', e, st);

        twitterApiErrorHandler(e);
      } else {
        yield bloc.state.copyWith(isFavoriting: false);
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
  Stream<TweetState> applyAsync({
    TweetState? currentState,
    TweetBloc? bloc,
  }) async* {
    log.fine('deleting tweet');

    final tweet = await bloc!.tweetService
        .destroy(id: bloc.state.tweet.id, trimUser: true)
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
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    yield bloc.state.copyWith(isTranslating: true);

    final translateLanguage = bloc.languagePreferences.activeTranslateLanguage(
      locale.languageCode,
    );

    final tweetTranslatable = bloc.state.tweet.translatable(translateLanguage);
    final quoteTranslatable = bloc.state.tweet.quoteTranslatable(
      translateLanguage,
    );

    Translation? tweetTranslation;
    Translation? quoteTranslation;

    await Future.wait<void>([
      // tweet translation
      if (tweetTranslatable)
        bloc.translationService
            .translate(
              text: bloc.state.tweet.visibleText,
              to: translateLanguage,
            )
            .then((translation) => tweetTranslation = translation)
            .handleError(silentErrorHandler),

      // quote translation
      if (quoteTranslatable)
        bloc.translationService
            .translate(
              text: bloc.state.tweet.quote!.visibleText,
              to: translateLanguage,
            )
            .then((translation) => quoteTranslation = translation)
            .handleError(silentErrorHandler)
    ]);

    // show an info when the tweet or quote was unable to be translated
    if (tweetTranslatable &&
        tweetTranslation != null &&
        tweetTranslation!.unchanged) {
      app<MessageService>().show('tweet not translated');
    } else if (quoteTranslatable &&
        quoteTranslation != null &&
        quoteTranslation!.unchanged) {
      app<MessageService>().show('quoted tweet not translated');
    }

    yield bloc.state.copyWith(
      tweet: bloc.state.tweet.copyWith(
        translation: tweetTranslation,
        quote: bloc.state.tweet.quote?.copyWith(
          translation: quoteTranslation,
        ),
      ),
    );
  }
}

abstract class MediaActionEvent extends TweetEvent {
  const MediaActionEvent({
    required this.tweet,
    this.index,
  });

  /// The tweet that has the action for the media.
  ///
  /// Can differ from [TweetState.tweet] when using media from quotes.
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

abstract class TweetActionEvent extends TweetEvent {
  const TweetActionEvent({
    required this.tweet,
  });

  /// The selected Tweet.
  ///
  /// Can differ from [TweetState.tweet] when selecting quotes.
  final TweetData tweet;
}

class OpenTweetExternally extends TweetActionEvent {
  const OpenTweetExternally({
    required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    unawaited(launchUrl(tweet.tweetUrl));
  }
}

class CopyTweetText extends TweetActionEvent {
  const CopyTweetText({
    required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    unawaited(Clipboard.setData(ClipboardData(text: tweet.visibleText)));
    app<MessageService>().show('copied tweet text');
  }
}

class ShareTweet extends TweetActionEvent {
  const ShareTweet({
    required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    required TweetState currentState,
    required TweetBloc bloc,
  }) async* {
    unawaited(Share.share(tweet.tweetUrl));
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

      return errors.any((dynamic error) =>
          error is Map<String, dynamic> &&
          (error['code'] == 139 ||
              error['code'] == 327 ||
              error['code'] == 144));
    } catch (e) {
      // unexpected error format
    }
  }

  return false;
}
