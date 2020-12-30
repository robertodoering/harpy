import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/translate/data/translation.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/download_service.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/url_launcher.dart';
import 'package:harpy/misc/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:share/share.dart';

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
class RetweetTweet extends TweetEvent {
  const RetweetTweet();

  static final Logger log = Logger('RetweetTweet');

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
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
class UnretweetTweet extends TweetEvent {
  const UnretweetTweet();

  static final Logger log = Logger('UnretweetTweet');

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
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
class FavoriteTweet extends TweetEvent {
  const FavoriteTweet();

  static final Logger log = Logger('FavoriteTweet');

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
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

/// Unfavorites the tweet.
class UnfavoriteTweet extends TweetEvent {
  const UnfavoriteTweet();

  static final Logger log = Logger('UnfavoriteTweet');

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
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
  const TranslateTweet();

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    yield TranslatingTweetState();

    await Future.wait<void>(<Future<void>>[
      // tweet translation
      if (bloc.tweet.translatable)
        bloc.translationService
            .translate(text: bloc.tweet.fullText)
            .then((Translation translation) =>
                bloc.tweet.translation = translation)
            .catchError(silentErrorHandler),

      // quote translation
      if (bloc.tweet.quoteTranslatable)
        bloc.translationService
            .translate(text: bloc.tweet.quote.fullText)
            .then((Translation translation) =>
                bloc.tweet.quote.translation = translation)
            .catchError(silentErrorHandler)
    ]);

    // show an info when the tweet or quote was unable to be translated
    if (bloc.tweet.translatable && bloc.tweet.translation?.unchanged != false) {
      app<MessageService>().show('Tweet not translated');
    } else if (bloc.tweet.quoteTranslatable &&
        bloc.tweet.quote.translation?.unchanged != false) {
      app<MessageService>().show('Quoted Tweet not translated');
    }

    yield UpdatedTweetState();
  }
}

abstract class MediaActionEvent extends TweetEvent {
  const MediaActionEvent({
    @required this.tweet,
    this.index,
  });

  /// The tweet that has the media to download.
  ///
  /// Can differ from [TweetBloc.tweet] when downloading media from quotes.
  final TweetData tweet;

  /// When the tweet media is of type image, the index determines which image
  /// gets downloaded.
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

/// Uses the [DownloadService] to download the media of a tweet.
class DownloadMedia extends MediaActionEvent {
  const DownloadMedia({
    @required TweetData tweet,
    int index,
  }) : super(tweet: tweet, index: index);

  static final Logger _log = Logger('DownloadMedia');

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    final DownloadService downloadService = app<DownloadService>();

    final String url = mediaUrl;
    final String fileName = fileNameFromUrl(url);

    if (url != null && fileName != null) {
      await downloadService
          .download(url: url, name: fileName)
          .catchError((dynamic error) {
        _log.severe('error while downloading tweet media', error);
      });
    } else {
      _log.warning('unable to get url or to parse filename from $url');
    }
  }
}

class OpenMediaExternally extends MediaActionEvent {
  const OpenMediaExternally({
    @required TweetData tweet,
    int index,
  }) : super(tweet: tweet, index: index);

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    final String url = mediaUrl;

    if (url != null) {
      launchUrl(url);
    }
  }
}

class ShareMedia extends MediaActionEvent {
  const ShareMedia({
    @required TweetData tweet,
    int index,
  }) : super(tweet: tweet, index: index);

  @override
  Stream<TweetState> applyAsync({
    TweetState currentState,
    TweetBloc bloc,
  }) async* {
    final String url = mediaUrl;

    if (url != null) {
      Share.share(url);
    }
  }
}
