import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/filesystem/cache_dir_service.dart';
import 'package:logging/logging.dart';

const String lastUpdated = "last_updated";

const String homeTimeline = "home_timeline";

class TweetCache {
  final Logger log = Logger('TweetCache');

  final String type;

  CacheDirectoryService cacheDirService = CacheDirectoryService();

  TweetCache() : type = homeTimeline;

  Future<List<Tweet>> checkCacheForTweets() async {
    List<Tweet> tweets = [];

    if (await _cacheNeedsToUpdate()) {
      log.shout("Cache needs to update!");
      return tweets;
    }

    return await getCachedTweets();
  }

  Future<List<Tweet>> getCachedTweets() async {
    List<Tweet> tweets = [];

    List<File> files = await cacheDirService.listFiles(
      currentBucketName,
      allowedFileExtension: ".json",
    );
    log.fine("Found ${files.length} cached Tweets!");

    files.forEach((file) {
      tweets.add(Tweet.fromJson(jsonDecode(file.readAsStringSync())));
    });

    // sort tweets by id
    tweets.sort((t1, t2) => t2.id - t1.id);

    return tweets;
  }

  Future<bool> tweetExists(Tweet tweet) async {
    List<File> files = await cacheDirService.listFiles(
      currentBucketName,
      allowedFileExtension: ".json",
    );

    return files.where((file) {
      // parse the id from the file path
      String id = file.path.substring(
        file.path.lastIndexOf("/") + 1,
        file.path.lastIndexOf("."),
      );

      return (tweet.id.toString() == id);
    }).isNotEmpty;
  }

  void clearCache() async {
    log.fine("Clear bucket $currentBucketName");
    List<File> files = await cacheDirService.listFiles(currentBucketName);

    files.forEach((file) => file.deleteSync());
  }

  void _setLastUpdatedDate() async {
    cacheDirService.createFile(
      currentBucketName,
      lastUpdated,
      ".txt",
      DateTime.now().toString(),
    );
  }

  Future<DateTime> _getLastUpdatedTime() async {
    try {
      return DateTime.parse(await cacheDirService.readFile(
        currentBucketName,
        lastUpdated,
        ".txt",
      ));
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

  /// Caches the [tweets] and clears the cache while keeping the
  /// [Tweet.harpyData] of the cached [Tweet].
  void updateCachedTweets(List<Tweet> tweets) async {
    List<Tweet> cachedTweets = await getCachedTweets();

    for (Tweet cachedTweet in cachedTweets) {
      Tweet tweet = tweets.firstWhere(
        (tweet) => tweet.id == cachedTweet.id,
        orElse: () => null,
      );

      if (tweet != null) tweet.harpyData = cachedTweet.harpyData;
    }

    // todo: improve:
//    for (Tweet tweet in tweets) {
//      // get cached file with tweet id if exists
//      // if exists: tweet.harpyData = cachedTweet.harpyData;
//    }

    clearCache();

    tweets.forEach(cacheTweet);
    _setLastUpdatedDate();
  }

  void cacheTweet(Tweet tweet) async {
    String fileName = "${tweet.id}";

    cacheDirService.createFile(
      currentBucketName,
      fileName,
      "json",
      jsonEncode(tweet.toJson()),
      rewrite: true,
    );
  }

  String get currentBucketName {
    String currentUserId = AppConfiguration().twitterSession.userId;
    return "tweets/$type/$currentUserId";
  }
}
