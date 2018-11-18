import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/filesystem/cache_dir_service.dart';
import 'package:logging/logging.dart';

class TweetCache {
  final Logger log = Logger('TweetCache');

  CacheDirectoryService _cacheDirService;

  String _lastUpdatedStorageFileName = "last_updated";

  TweetCache() {
    _cacheDirService = CacheDirectoryService();
  }

  Future<List<Tweet>> checkCacheForTweets() async {
    List<Tweet> tweets = [];

    if (await _cacheNeedsToUpdate()) {
      log.shout("Cache needs to update!");
      return tweets;
    }

    tweets = await getCachedTweets();

    return tweets;
  }

  Future<List<Tweet>> getCachedTweets() async {
    List<Tweet> tweets = [];

    List<File> files = await _cacheDirService.listFiles(currentBucketName,
        allowedFileExtension: ".json");
    log.fine("Found ${files.length} cached Tweets!");

    files.forEach((file) {
      tweets.add(Tweet.fromJson(jsonDecode(file.readAsStringSync())));
    });

    // sort tweets by id
    tweets.sort((t1, t2) => t2.id - t1.id);

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
    _setLastUpdatedDate();
  }

  void _setLastUpdatedDate() async {
    _cacheDirService.createFile(currentBucketName, _lastUpdatedStorageFileName,
        ".txt", DateTime.now().toString());
  }

  Future<DateTime> _getLastUpdatedTime() async {
    try {
      return DateTime.parse(await _cacheDirService.readFile(
          currentBucketName, _lastUpdatedStorageFileName, ".txt"));
    } catch (ex) {
      return null;
    }
  }

  Future<bool> _cacheNeedsToUpdate() async {
    DateTime lastUpdate = await _getLastUpdatedTime();
    if (lastUpdate == null) {
      return true;
    }
    return DateTime.now().difference(lastUpdate).inMinutes >=
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
