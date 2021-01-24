import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tweet_search_event.dart';
part 'tweet_search_state.dart';

class TweetSearchBloc extends Bloc<TweetSearchEvent, TweetSearchState> {
  TweetSearchBloc() : super(TweetSearchInitial());

  @override
  Stream<TweetSearchState> mapEventToState(
    TweetSearchEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
