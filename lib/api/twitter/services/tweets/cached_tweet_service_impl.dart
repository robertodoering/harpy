import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/filesystem/cache_dir_service.dart';
import 'package:logging/logging.dart';

class CachedTweetServiceImpl extends TweetServiceImpl implements TweetService {
  final Logger log = new Logger('CachedTweetServiceImpl');

  CacheDirectoryService _cacheDirService;

  CachedTweetServiceImpl() {
    _cacheDirService = CacheDirectoryService();
  }

  @override
  Future<List<Tweet>> getHomeTimeline() async {
    log.finest("Tryin to get Home Timeline Data");
    List<Tweet> tweets = [];
    tweets = await _checkCacheForTweets();

    if (tweets.isNotEmpty) {
      log.fine("Using cached data");
      return tweets;
    }
    tweets = await super.getHomeTimeline();
    log.fine("Requested to Twitter API got ${tweets.length} records");

    _cacheTweets(tweets);
    log.fine("Store them on device");

    return tweets;
  }

  Future<List<Tweet>> _checkCacheForTweets() async {
    List<Tweet> tweets = [];
    List<File> files = await _cacheDirService.listFiles(currentBucketName);
    log.fine("Found ${files.length} cached Tweets!");

    files.forEach((file) {
      if (file.lastModifiedSync().difference(DateTime.now()).inHours == 4) {
        file.deleteSync();
      } else {
        tweets.add(Tweet.fromJson(jsonDecode(file.readAsStringSync())));
      }
    });

    return tweets;
  }

  void _cacheTweets(List<Tweet> tweets) {
    tweets.forEach((tweet) => _cacheTweet(tweet));
  }

  void _cacheTweet(Tweet tweet) {
    String fileName = "${tweet.id}_${DateTime.now().toIso8601String()}";

    _cacheDirService.createFile(
      currentBucketName,
      fileName,
      "json",
      jsonEncode(tweet.toJson()),
      rewrite: true,
    );
  }

  String get currentBucketName {
    String currentUserId = AppConfiguration().twitterSession.userId;
    return "tweets/$currentUserId";
  }
}
