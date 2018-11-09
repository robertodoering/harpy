import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/filesystem/cache_dir_service.dart';
import 'package:logging/logging.dart';

class TweetCache {
  final Logger log = new Logger('TweetCache');

  CacheDirectoryService _cacheDirService;

  TweetCache() {
    _cacheDirService = CacheDirectoryService();
  }

  Future<List<Tweet>> checkCacheForTweets() async {
    List<Tweet> tweets = [];
    List<File> files = await _cacheDirService.listFiles(currentBucketName);
    log.fine("Found ${files.length} cached Tweets!");

    files.forEach((file) {
      if (_isFileValidForCache(file)) {
        file.deleteSync();
      } else {
        tweets.add(Tweet.fromJson(jsonDecode(file.readAsStringSync())));
      }
    });

    return tweets;
  }

  void cacheTweets(List<Tweet> tweets) {
    tweets.forEach((tweet) => cacheTweet(tweet));
  }

  bool _isFileValidForCache(File file) {
    return file.lastModifiedSync().difference(DateTime.now()).inHours ==
        AppConfiguration()
            .applicationConfig
            .cacheConfiguration
            .tweetCacheTimeInHours;
  }

  void cacheTweet(Tweet tweet) {
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
