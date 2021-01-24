part of 'tweet_search_bloc.dart';

abstract class TweetSearchEvent {
  const TweetSearchEvent();

  Stream<TweetSearchState> applyAsync({
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  });
}
