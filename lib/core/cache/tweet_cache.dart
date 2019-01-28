import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

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
  TweetCache({
    @required this.directoryService,
  }) : assert(directoryService != null);

  /// Constructs a [TweetCache] from the [TweetCacheData].
  ///
  /// Used by isolates.
  TweetCache.data({@required this.directoryService, @required this.data});

  final DirectoryService directoryService;

  static final Logger _log = Logger("TweetCache");

  /// Instance that can be used in isolates.
  static TweetCache isolateInstance;

  /// The [data] used to construct a [TweetCache] for isolates.
  TweetCacheData data = TweetCacheData();

  /// Sets the [TweetCacheData.loggedInUserId] for the bucket.
  void initLoggedInUser(String loggedInUserId) {
    data.loggedInUserId = loggedInUserId;
  }

  /// The sub directory where the files are stored.
  ///
  /// [Tweet]s should be cached for each logged in user separately.
  String get bucket {
    // make sure the data has been set before accessing the bucket
    assert(data.type != null);
    assert(data.loggedInUserId != null);

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

    directoryService.createFile(
      bucket: bucket,
      name: fileName,
      content: jsonEncode(tweet.toJson()),
    );
  }

  /// Updates a [Tweet] in the cache if it exists in the [bucket].
  void updateTweet(Tweet tweet) {
    _log.fine("updating cached tweet for $bucket");

    bool exists = tweetExists(tweet);

    if (exists) {
      _cacheTweet(tweet);
      _log.fine("tweet updated");
    } else {
      _log.warning("tweet not found in cache");
    }
  }

  /// Gets a list of [Tweet]s that are cached as files inside the temporary
  /// device directory in the [bucket].
  ///
  /// If no cached [Tweet]s are found the returned list will be empty.
  List<Tweet> getCachedTweets() {
    _log.fine("getting cached tweets for bucket: $bucket");

    List<Tweet> tweets = [];

    List<File> files = directoryService.listFiles(
      bucket: bucket,
      extension: ".json",
    );

    _log.fine("found ${files.length} cached tweets");

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
    _log.fine("updating cached tweets");

    for (Tweet tweet in tweets) {
      String fileName = "${tweet.id}.json";

      File cachedFile = directoryService.getFile(
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
    File file = directoryService.getFile(
      bucket: bucket,
      name: "${tweet.id}.json",
    );

    return file != null;
  }

  /// Returns the cached [Tweet] for the [id] or `null` if it doesn't exist in
  /// the cache.
  Tweet getTweet(String id) {
    File file = directoryService.getFile(
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
    _log.fine("clear bucket $bucket");
    List<File> files = directoryService.listFiles(bucket: bucket);

    files.forEach((file) => file.deleteSync());
  }
}
