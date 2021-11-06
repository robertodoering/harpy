part of 'likes_timeline_bloc.dart';

abstract class LikesTimelineEvent {
  const LikesTimelineEvent();

  Future<void> handle(LikesTimelineBloc bloc, Emitter emit);
}

/// Requests the likes timeline tweets for the [LikesTimelineBloc.handle].
class RequestLikesTimeline extends LikesTimelineEvent with HarpyLogger {
  const RequestLikesTimeline();

  @override
  Future<void> handle(LikesTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting likes timeline');

    emit(const LikesTimelineInitialLoading());

    String? maxId;

    final tweets = await app<TwitterApi>()
        .tweetService
        .listFavorites(
          screenName: bloc.handle,
          count: 200,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then(handleTweets)
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        emit(
          LikesTimelineResult(
            tweets: tweets,
            maxId: maxId,
          ),
        );
      } else {
        emit(const LikesTimelineNoResult());
      }
    } else {
      emit(const LikesTimelineFailure());
    }
  }
}

/// An event to request older likes timeline tweets.
///
/// This is used when the end of the likes timeline has been reached and the
/// user wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a likes timeline can be requested.
class RequestOlderLikesTimeline extends LikesTimelineEvent with HarpyLogger {
  const RequestOlderLikesTimeline();

  String? _findMaxId(LikesTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Future<void> handle(LikesTimelineBloc bloc, Emitter emit) async {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    final state = bloc.state;

    if (state is LikesTimelineResult) {
      final maxId = _findMaxId(state);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older likes timeline tweets');

      emit(LikesTimelineLoadingOlder(oldResult: state));

      String? newMaxId;
      var canRequestOlder = false;

      final tweets = await app<TwitterApi>()
          .tweetService
          .listFavorites(
            screenName: bloc.handle,
            count: 200,
            maxId: maxId,
          )
          .then((tweets) {
            if (tweets.isNotEmpty) {
              newMaxId = tweets.last.idStr;
              canRequestOlder = true;
            } else {
              canRequestOlder = false;
            }
            return tweets;
          })
          .then(handleTweets)
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log
          ..fine('found ${tweets.length} older tweets')
          ..finer('can request older: $canRequestOlder');

        emit(
          LikesTimelineResult(
            tweets: state.tweets.followedBy(tweets).toList(),
            maxId: newMaxId,
            canRequestOlder: canRequestOlder,
          ),
        );
      } else {
        // re-yield result state with previous tweets but new max id
        emit(
          LikesTimelineResult(
            tweets: state.tweets,
            maxId: state.maxId,
          ),
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}
