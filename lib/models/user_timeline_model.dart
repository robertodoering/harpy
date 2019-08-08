import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class UserTimelineModel extends TimelineModel {
  UserTimelineModel({
    @required this.userId,
  }) : assert(userId != null) {
    initTweets();
  }

  final int userId;

  static UserTimelineModel of(BuildContext context) {
    return Provider.of<UserTimelineModel>(context);
  }

  static final Logger _log = Logger("UserTimelineModel");

  @override
  Future<List<Tweet>> getCachedTweets() {
    return timelineDatabase.findUserTimelineTweets(userId);
  }

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");
    loadingInitialTweets = tweets.isEmpty;
    notifyListeners();

    final List<Tweet> updatedTweets = await tweetService
        .getUserTimeline("$userId")
        .catchError(twitterClientErrorHandler);

    if (updatedTweets != null) {
      tweets = updatedTweets;
      timelineDatabase.recordUserTimelineIds(userId, updatedTweets);
      tweetDatabase.recordTweetList(updatedTweets);
    }

    loadingInitialTweets = false;
    notifyListeners();
  }

  @override
  Future<void> requestMore() async {
    await super.requestMore();

    final id = "${tweets.last.id - 1}";

    final List<Tweet> newTweets = await tweetService
        .getUserTimeline("$userId", maxId: id)
        .catchError(twitterClientErrorHandler);

    if (newTweets != null) {
      // todo: maybe add new tweets to cached user timeline ids
      addNewTweets(newTweets);
    }

    requestingMore = false;
    notifyListeners();
  }
}
