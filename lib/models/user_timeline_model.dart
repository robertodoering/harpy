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

  final String userId;

  static UserTimelineModel of(BuildContext context) {
    return Provider.of<UserTimelineModel>(context);
  }

  static final Logger _log = Logger("UserTimelineModel");

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");
    loadingInitialTweets = tweets.isEmpty;
    notifyListeners();

    final List<Tweet> updatedTweets = await tweetService
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
    await super.requestMore();

    final id = "${tweets.last.id - 1}";

    // todo: bug: clears cached tweets where id > than id
    final List<Tweet> newTweets = await tweetService.getUserTimeline(
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
