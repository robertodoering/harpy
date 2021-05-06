import 'dart:async';
import 'dart:convert';

import 'package:dart_twitter_api/api/tweets/tweet_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:http/http.dart';
import 'package:pedantic/pedantic.dart';
import 'package:share/share.dart';

part 'tweet_event.dart';
part 'tweet_state.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
class TweetBloc extends Bloc<TweetEvent, TweetState> {
  TweetBloc(this.tweet) : super(InitialState());

  final TweetData tweet;

  final TweetService tweetService = app<TwitterApi>().tweetService;

  final TranslationService translationService = app<TranslationService>();

  final LanguagePreferences languagePreferences = app<LanguagePreferences>();

  static TweetBloc of(BuildContext context) => context.watch<TweetBloc>();

  /// Returns the download url for the [tweet].
  String? downloadMediaUrl(TweetData tweet, {int? index}) {
    if (tweet.hasMedia) {
      if (tweet.images?.isNotEmpty == true) {
        return tweet.images![index ?? 0].bestUrl;
      } else if (tweet.gif != null) {
        return tweet.gif!.bestUrl;
      } else if (tweet.video != null) {
        return tweet.video!.bestUrl;
      }
    }

    return null;
  }

  @override
  Stream<TweetState> mapEventToState(
    TweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
