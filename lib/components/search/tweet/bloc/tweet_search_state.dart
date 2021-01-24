part of 'tweet_search_bloc.dart';

abstract class TweetSearchState extends Equatable {
  const TweetSearchState();
}

class TweetSearchInitial extends TweetSearchState {
  @override
  List<Object> get props => <Object>[];
}
