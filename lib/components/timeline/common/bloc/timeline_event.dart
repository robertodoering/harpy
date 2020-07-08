import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/core/api/handle_tweets.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/tweet_data.dart';

@immutable
abstract class TimelineEvent {
  const TimelineEvent();

  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  });
}

abstract class UpdateTimelineEvent extends TimelineEvent {
  const UpdateTimelineEvent();

  Future<List<Tweet>> requestTimeline(TimelineBloc bloc);

  @override
  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  }) async* {
    final List<TweetData> tweets = await requestTimeline(bloc)
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      bloc.tweets = tweets;
      yield const ShowingTimelineState();
    }
  }
}
