import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/filesystem/cache_dir_service.dart';
import 'package:logging/logging.dart';

class TweetCache {
  final Logger log = Logger('TweetCache');

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

  void clearCache() async {
    log.fine("Clear bucket $currentBucketName");
    List<File> files = await _cacheDirService.listFiles(currentBucketName);

    files.forEach((file) {
      log.fine("Try to delete ${file.path}");
      file.deleteSync();
    });
  }

  void cacheTweets(List<Tweet> tweets) {
    tweets.forEach(cacheTweet);
  }

  bool _isFileValidForCache(File file) {
    return file.lastModifiedSync().difference(DateTime.now()).inHours ==
        AppConfiguration()
            .applicationConfig
            .cacheConfiguration
            .tweetCacheTimeInHours;
  }

  void cacheTweet(Tweet tweet) {
    String fileName = "${tweet.id}";

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

  set cacheDirService(CacheDirectoryService value) {
    _cacheDirService = value;
  }
}
