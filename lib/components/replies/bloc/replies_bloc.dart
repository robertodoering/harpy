import 'package:dart_twitter_api/api/tweets/tweet_search_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_event.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';

class RepliesBloc extends Bloc<RepliesEvent, RepliesState> {
  RepliesBloc(this.tweet) : super(LoadingRepliesState()) {
    add(const LoadRepliesEvent());
  }

  final TweetData tweet;

  final TweetService tweetService = app<TwitterApi>().tweetService;
  final TweetSearchService searchService = app<TwitterApi>().tweetSearchService;

  static RepliesBloc of(BuildContext context) => context.bloc<RepliesBloc>();

  /// If this [tweet] is a reply itself, this list will contain all parent
  /// tweets.
  List<TweetData> parentTweets = <TweetData>[];

  /// The list of replies for this [tweet].
  List<TweetData> replies = <TweetData>[];

  /// The last tweet search response.
  RepliesResult lastResult;

  /// Whether all replies have been loaded.
  bool get allRepliesLoaded => lastResult?.lastPage ?? true;

  /// Whether no replies exists for this [tweet].
  bool get noRepliesExists => state is LoadedRepliesState && replies.isEmpty;

  @override
  Stream<RepliesState> mapEventToState(
    RepliesEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
