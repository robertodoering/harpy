import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/error_handler.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class UserTimelineModel extends TimelineModel {
  UserTimelineModel({
    @required this.userId,
    @required TweetService tweetService,
    @required UserTimelineCache userTimelineCache,
  })  : assert(userId != null),
        super(tweetService: tweetService, tweetCache: userTimelineCache) {
    userTimelineCache.user(userId);
    initTweets();
  }

  final String userId;

  static final Logger _log = Logger("UserTimelineModel");

  static UserTimelineModel of(BuildContext context) {
    return Provider.of<UserTimelineModel>(context);
  }

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");
    loadingInitialTweets = tweets.isEmpty;
    notifyListeners();

    List<Tweet> updatedTweets = await tweetService
        .getUserTimeline(userId)
        .catchError(twitterClientErrorHandler);

    if (updatedTweets != null) {
      tweets = updatedTweets;
    }

    loadingInitialTweets = false;
    notifyListeners();
  }

  @override
  Future<void> requestMore() async {
    (tweetCache as UserTimelineCache).user(userId);
    await super.requestMore();

    String id = "${tweets.last.id - 1}";

    // todo: bug: clears cached tweets where id > than id
    List<Tweet> newTweets = await tweetService.getUserTimeline(
      userId,
      params: {"max_id": id},
    ).catchError(twitterClientErrorHandler);

    if (newTweets != null) {
      addNewTweets(newTweets);
    }

    requestingMore = false;
    notifyListeners();
  }
}
