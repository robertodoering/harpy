part of 'tweet_bloc.dart';

@immutable
abstract class TweetEvent {
  const TweetEvent();

  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  });

  /// Returns `true` if the error contains any of the following error codes:
  ///
  /// 139: already favorited (trying to favorite a tweet twice)
  /// 327: already retweeted
  /// 144: tweet with id not found (trying to unfavorite a tweet twice) or
  /// trying to delete a tweet that has already been deleted before.
  bool actionPerformed(dynamic error) {
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
}

/// Retweets the tweet.
class RetweetTweet extends TweetEvent with HarpyLogger {
  const RetweetTweet();

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    HapticFeedback.lightImpact();

    bloc.tweet.retweeted = true;
    bloc.tweet.retweetCount++;
    yield UpdatedTweetState();

    try {
      await bloc.tweetService.retweet(id: bloc.tweet.idStr);
      log.fine('retweeted ${bloc.tweet.idStr}');
    } catch (e, st) {
      if (!actionPerformed(e)) {
        bloc.tweet.retweeted = false;
        bloc.tweet.retweetCount--;
        log.warning('error retweeting ${bloc.tweet.idStr}', e, st);
        yield UpdatedTweetState();
      }
    }
  }
}

/// Unretweets the tweet.
class UnretweetTweet extends TweetEvent with HarpyLogger {
  const UnretweetTweet();

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    HapticFeedback.lightImpact();

    bloc.tweet.retweeted = false;
    bloc.tweet.retweetCount--;
    yield UpdatedTweetState();

    try {
      await bloc.tweetService.unretweet(id: bloc.tweet.idStr);
      log.fine('unretweeted ${bloc.tweet.idStr}');
    } catch (e, st) {
      if (!actionPerformed(e)) {
        bloc.tweet.retweeted = true;
        bloc.tweet.retweetCount++;
        log.warning('error unretweeting ${bloc.tweet.idStr}', e, st);
        yield UpdatedTweetState();
      }
    }
  }
}

/// Favorites the tweet.
class FavoriteTweet extends TweetEvent with HarpyLogger {
  const FavoriteTweet();

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    HapticFeedback.lightImpact();

    bloc.tweet.favorited = true;
    bloc.tweet.favoriteCount++;
    yield UpdatedTweetState();

    try {
      await bloc.tweetService.createFavorite(id: bloc.tweet.idStr);
      log.fine('favorited ${bloc.tweet.idStr}');
    } catch (e, st) {
      if (!actionPerformed(e)) {
        bloc.tweet.favorited = false;
        bloc.tweet.favoriteCount--;
        log.warning('error favoriting ${bloc.tweet.idStr}', e, st);
        yield UpdatedTweetState();
      }
    }
  }
}

class DeleteTweet extends TweetEvent with HarpyLogger {
  DeleteTweet({
    this.onDeleted,
  });

  final VoidCallback onDeleted;

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    log.fine('deleting tweet');

    final Tweet tweet = await bloc.tweetService
        .destroy(id: bloc.tweet.idStr, trimUser: true)
        .catchError(silentErrorHandler);

    if (tweet != null) {
      app<MessageService>().show('tweet deleted');
      onDeleted?.call();
    } else {
      app<MessageService>().show('error deleting tweet');
    }
  }
}

/// Unfavorites the tweet.
class UnfavoriteTweet extends TweetEvent with HarpyLogger {
  const UnfavoriteTweet();

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    HapticFeedback.lightImpact();

    bloc.tweet.favorited = false;
    bloc.tweet.favoriteCount--;
    yield UpdatedTweetState();

    try {
      await bloc.tweetService.destroyFavorite(id: bloc.tweet.idStr);
      log.fine('unfavorited ${bloc.tweet.idStr}');
    } catch (e, st) {
      if (!actionPerformed(e)) {
        bloc.tweet.favorited = true;
        bloc.tweet.favoriteCount++;
        log.warning('error unfavoriting ${bloc.tweet.idStr}', e, st);
        yield UpdatedTweetState();
      }
    }
  }
}

/// Translates the tweet.
///
/// The [Translation] is saved in the [TweetData.translation].
class TranslateTweet extends TweetEvent {
  const TranslateTweet({
    @required this.locale,
  });

  final Locale locale;

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    HapticFeedback.lightImpact();

    yield TranslatingTweetState();

    final String translateLanguage =
        bloc.languagePreferences.activeTranslateLanguage(locale.languageCode);

    final bool tweetTranslatable = bloc.tweet.translatable(translateLanguage);
    final bool quoteTranslatable = bloc.tweet.quoteTranslatable(
      translateLanguage,
    );

    await Future.wait<void>(<Future<void>>[
      // tweet translation
      if (tweetTranslatable)
        bloc.translationService
            .translate(text: bloc.tweet.fullText, to: translateLanguage)
            .then((Translation translation) =>
                bloc.tweet.translation = translation)
            .catchError(silentErrorHandler),

      // quote translation
      if (quoteTranslatable)
        bloc.translationService
            .translate(text: bloc.tweet.quote.fullText, to: translateLanguage)
            .then((Translation translation) =>
                bloc.tweet.quote.translation = translation)
            .catchError(silentErrorHandler)
    ]);

    // show an info when the tweet or quote was unable to be translated
    if (tweetTranslatable && bloc.tweet.translation?.unchanged != false) {
      app<MessageService>().show('tweet not translated');
    } else if (quoteTranslatable &&
        bloc.tweet.quote.translation?.unchanged != false) {
      app<MessageService>().show('quoted tweet not translated');
    }

    yield UpdatedTweetState();
  }
}

abstract class MediaActionEvent extends TweetEvent {
  const MediaActionEvent({
    @required this.tweet,
    this.index,
  });

  /// The tweet that has the action for the media.
  ///
  /// Can differ from [TweetBloc.tweet] when using media from quotes.
  final TweetData tweet;

  /// When the tweet media is of type image, the index determines which image
  /// to select.
  final int index;

  /// Returns the url of the selected media or `null` if no url exist.
  String get mediaUrl {
    if (tweet.hasMedia) {
      if (tweet.images?.isNotEmpty == true) {
        return tweet.images[index ?? 0]?.baseUrl;
      } else if (tweet.gif != null) {
        return tweet.gif.variants?.first?.url;
      } else if (tweet.video != null) {
        return tweet.video.variants?.first?.url;
      }
    }

    return null;
  }
}

abstract class TweetActionEvent extends TweetEvent {
  const TweetActionEvent({
    @required this.tweet,
  });

  /// The selected Tweet.
  ///
  /// Can differ from [TweetBloc.tweet] when selecting quotes.
  final TweetData tweet;
}

class OpenTweetExternally extends TweetActionEvent {
  const OpenTweetExternally({
    @required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    launchUrl(tweet.tweetUrl);
  }
}

class CopyTweetText extends TweetActionEvent {
  const CopyTweetText({
    @required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    Clipboard.setData(ClipboardData(text: tweet.visibleText));
    app<MessageService>().show('copied tweet text');
  }
}

class ShareTweet extends TweetActionEvent {
  const ShareTweet({
    @required TweetData tweet,
  }) : super(tweet: tweet);

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    Share.share(tweet.tweetUrl);
  }
}
