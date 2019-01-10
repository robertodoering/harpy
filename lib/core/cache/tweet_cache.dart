import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:logging/logging.dart';

class TweetCache {
  final Logger log = Logger("TweetCache");

  static const String lastUpdated = "last_updated.txt";

  static const String homeTimeline = "home_timeline";
  static const String userTimeline = "user_timeline";

  /// The [_type] affects the location of the [bucket].
  String _type;

  /// The [_userId] for the [User] to cache the user timeline.
  String _userId;

  static TweetCache _instance = TweetCache._();

  factory TweetCache.home() => _instance
    .._type = homeTimeline
    .._userId = null;

  factory TweetCache.user(String userId) => _instance
    .._type = userTimeline
    .._userId = userId;

  TweetCache._();

  /// The sub directory where the files are stored.
  ///
  /// [Tweet]s should be cached for each logged in user separately.
  String get bucket {
    String currentUserId = AppConfiguration().twitterSession.userId;

    String bucket = "tweets/$_type/$currentUserId";

    if (_userId != null) bucket += "/$_userId";

    return bucket;
  }

  /// Caches the [tweet].
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

  /// Updates a [Tweet] in the cache if it exists.
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
  void updateCachedTweets(List<Tweet> tweets) {
    log.fine("updating cached tweets");

    clearBucket();

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

      _cacheTweet(tweet);
    }

//    _setLastUpdatedDate(); // todo: necessary?
  }

  /// Creates a the lastUpdated file with the [DateTime.now].
  void _setLastUpdatedDate() async {
    DirectoryService().createFile(
      bucket: bucket,
      name: lastUpdated,
      content: DateTime.now().toString(),
    );
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

  // todo: necessary?
  bool cacheShouldUpdate() {
    File lastUpdatedFile = DirectoryService().getFile(
      bucket: bucket,
      name: lastUpdated,
    );

    if (lastUpdatedFile == null) {
      return true;
    } else {
      DateTime lastUpdatedTime =
          DateTime.parse(lastUpdatedFile.readAsStringSync());

      return DateTime.now().difference(lastUpdatedTime).inHours >= 4;
    }
  }
}
