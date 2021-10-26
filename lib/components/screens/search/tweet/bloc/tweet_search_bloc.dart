import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:logging/logging.dart';

part 'tweet_search_event.dart';
part 'tweet_search_state.dart';

class TweetSearchBloc extends Bloc<TweetSearchEvent, TweetSearchState> {
  TweetSearchBloc({
    String? initialSearchQuery,
  }) : super(const TweetSearchInitial()) {
    if (initialSearchQuery != null && initialSearchQuery.trim().isNotEmpty) {
      add(SearchTweets(customQuery: initialSearchQuery));
    }
  }

  @override
  Stream<TweetSearchState> mapEventToState(
    TweetSearchEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
