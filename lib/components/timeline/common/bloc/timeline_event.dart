import 'dart:async';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/handle_tweets.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:logging/logging.dart';

@immutable
abstract class TimelineEvent {
  const TimelineEvent();

  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  });
}

/// Updates the [TimelineBloc.tweets] for this timeline to the newest tweets.
abstract class UpdateTimelineEvent extends TimelineEvent {
  const UpdateTimelineEvent();

  static final Logger _log = Logger('UpdateTimelineEvent');

  Future<List<Tweet>> requestTimeline(TimelineBloc bloc);

  @override
  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  }) async* {
    _log.fine('updating timeline');

    yield UpdatingTimelineState();

    final List<TweetData> tweets = await requestTimeline(bloc)
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      _log.fine('updated timeline with ${tweets.length} tweets');

      bloc.tweets = tweets;

      if (tweets.isNotEmpty) {
        yield ShowingTimelineState();
      } else {
        yield NoTweetsFoundState();
      }
    } else {
      yield FailedLoadingTimelineState();
    }

    bloc.updateTimelineCompleter.complete();
    bloc.updateTimelineCompleter = Completer<void>();
  }
}

/// Requests new tweets for this timeline and appends them to the
/// [TimelineBloc.tweets].
///
/// [TimelineBloc.tweets] must not be empty to request more.
abstract class RequestMoreTimelineEvent extends TimelineEvent {
  const RequestMoreTimelineEvent();

  static final Logger _log = Logger('RequestMoreTimelineEvent');

  Future<List<Tweet>> requestMore(TimelineBloc bloc);

  /// Finds the `maxId` for the request.
  ///
  /// The `maxId` is equal to one below the id of the last tweet in the
  /// [bloc.tweets] list.
  String findMaxId(TimelineBloc bloc) {
    if (bloc.tweets.isNotEmpty) {
      final int lastId = int.tryParse(bloc.tweets.last.idStr);

      if (lastId != null) {
        return '${lastId - 1}';
      }
    }

    return null;
  }

  /// Prevents successive [RequestMoreTimelineEvent]s to trigger and adds a
  /// [UnlockRequestMoreTimelineEvent] to the [bloc] after 5 minutes to unlock
  /// future requests.
  void _lockRequestMore(TimelineBloc bloc) {
    bloc.lockRequestMore = true;

    Future<void>.delayed(const Duration(minutes: 5)).then((_) {
      if (bloc?.state is ShowingTimelineState) {
        bloc?.add(const UnlockRequestMoreTimelineEvent());
      } else {
        bloc?.lockRequestMore = false;
      }
    });
  }

  @override
  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  }) async* {
    _log.fine('requesting more');

    if (bloc.lockRequestMore) {
      _log.warning('tried to request more while still locked');
    } else {
      // lock successive requests
      _lockRequestMore(bloc);
    }

    final List<TweetData> tweets = await requestMore(bloc)
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      _log.fine('found more tweets');

      bloc.tweets.addAll(tweets);
    }

    // always rebuild to lock successive requests
    yield ShowingTimelineState();

    bloc.requestMoreCompleter.complete();
    bloc.requestMoreCompleter = Completer<void>();
  }
}

/// Sets the [TimelineBloc.lockRequestMore] flag to `false` to unlock requesting
/// more and rebuilds the timeline.
class UnlockRequestMoreTimelineEvent extends TimelineEvent {
  const UnlockRequestMoreTimelineEvent();

  static final Logger _log = Logger('UnlockRequestMoreTimelineEvent');

  @override
  Stream<TimelineState> applyAsync({
    TimelineState currentState,
    TimelineBloc bloc,
  }) async* {
    _log.fine('unlocking request more');

    bloc.lockRequestMore = false;

    yield ShowingTimelineState();
  }
}
