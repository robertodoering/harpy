import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:logging/logging.dart';

/// The [TweetCacheData] is used to construct a [TweetCache] for isolates.
class TweetCacheData {
  /// The [loggedInUserId] affects the location of the [TweetCache.bucket].
  String loggedInUserId;

  /// The [type] affects the location of the [TweetCache.bucket].
  String type;

  /// The [userId] for the [User] to cache the user timeline.
  String userId;
}

class TweetCache {
  static Logger log = Logger("TweetCache");

  static const String homeTimeline = "home_timeline";
  static const String userTimeline = "user_timeline";

  /// The [data] used to construct a [TweetCache] for isolates.
  TweetCacheData data = TweetCacheData();

  static TweetCache _instance = TweetCache._();
  TweetCache._();

  factory TweetCache(TweetCacheData data) {
    _instance.data.loggedInUserId = data.loggedInUserId;
    _instance.data.type = data.type;
    _instance.data.userId = data.userId;

    return _instance;
  }

  /// Returns the [_instance] and assumes it has been initialized previously.
  ///
  /// Should only be used in isolates.
  factory TweetCache.initialized() => _instance;

  factory TweetCache.home() {
    _instance.data.loggedInUserId = AppConfiguration().twitterSession.userId;
    _instance.data.type = homeTimeline;
    _instance.data.userId = null;

    return _instance;
  }

  factory TweetCache.user(String userId) {
    _instance.data.loggedInUserId = AppConfiguration().twitterSession.userId;
    _instance.data.type = userTimeline;
    _instance.data.userId = userId;

    return _instance;
  }

  /// The sub directory where the files are stored.
  ///
  /// [Tweet]s should be cached for each logged in user separately.
  String get bucket {
    String bucket = "tweets/${data.type}/${data.loggedInUserId}";

    if (data.userId != null) {
      bucket += "/${data.userId}";
    }

    return bucket;
  }

  /// Caches the [tweet] in the [bucket].
  ///
  /// If a [Tweet] with the same [Tweet.id] already exists it will be
  /// overridden.
  void _cacheTweet(Tweet tweet) {
    String fileName = "${tweet.id}.json";

    DirectoryService().createFile(
      bucket: bucket,
      name: fileName,
      content: jsonEncode(tweet.toJson()),
    );
  }

  /// Updates a [Tweet] in the cache if it exists in the [bucket].
  void updateTweet(Tweet tweet) {
    log.fine("updating cached tweet");

    bool exists = tweetExists(tweet);

    if (exists) {
      _cacheTweet(tweet);
      log.fine("tweet updated");
    } else {
      log.warning("tweet not found in cache");
    }
  }

  /// Gets a list of [Tweet]s that are cached as files inside the temporary
  /// device directory in the [bucket].
  ///
  /// If no cached [Tweet]s are found the returned list will be empty.
  List<Tweet> getCachedTweets() {
    log.fine("getting cached tweets");

    List<Tweet> tweets = [];

    List<File> files = DirectoryService().listFiles(
      bucket: bucket,
      extension: ".json",
    );

    log.fine("found ${files.length} cached tweets");

    for (File file in files) {
      tweets.add(Tweet.fromJson(jsonDecode(file.readAsStringSync())));
    }

    // sort tweets by id
    tweets.sort((t1, t2) => t2.id - t1.id);

    return tweets;
  }

  /// Clears the cache and caches a new list of [tweets] while retaining the
  /// [Tweet.harpyData] of the cached [Tweet] if it is the same.
  List<Tweet> updateCachedTweets(List<Tweet> tweets) {
    log.fine("updating cached tweets");

    for (Tweet tweet in tweets) {
      String fileName = "${tweet.id}.json";

      File cachedFile = DirectoryService().getFile(
        bucket: bucket,
        name: fileName,
      );

      if (cachedFile != null) {
        // copy harpy data from the cached tweet if the tweet has been cached
        // before

        Tweet cachedTweet =
            Tweet.fromJson(jsonDecode(cachedFile.readAsStringSync()));

        tweet.harpyData = cachedTweet.harpyData;
      }
    }

    clearBucket();

    tweets.forEach(_cacheTweet);

    return tweets;
  }

  /// Returns `true` if the [Tweet] exists in the cache.
  bool tweetExists(Tweet tweet) {
    File file = DirectoryService().getFile(
      bucket: bucket,
      name: "${tweet.id}.json",
    );

    return file != null;
  }

  /// Returns the cached [Tweet] for the [id] or `null` if it doesn't exist in
  /// the cache.
  Tweet getTweet(String id) {
    File file = DirectoryService().getFile(
      bucket: bucket,
      name: "$id.json",
    );

    if (file == null) {
      return null;
    } else {
      return Tweet.fromJson(jsonDecode(file.readAsStringSync()));
    }
  }

  /// Deletes every [File] in the [bucket].
  void clearBucket() {
    log.fine("clear bucket $bucket");
    List<File> files = DirectoryService().listFiles(bucket: bucket);

    files.forEach((file) => file.deleteSync());
  }
}

// todo
Future<void> isolateUpdateTweetCache(List args) async {
  List<Tweet> tweets = args[0];
//  String type = args[1];
//  String userId = args[2];
//  String path = args[3];

  TweetCacheData data = args[1];
  String path = args[2];

  print("isolate update tweet cache");
//  print("${tweets.length} tweets exist");
//  print("type: $type");
//  print("userid: $userId");

  DirectoryService().data.path = path;

  print("directory service init");

  TweetCache(data).updateCachedTweets(tweets);
}
