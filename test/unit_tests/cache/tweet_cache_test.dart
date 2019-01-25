import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';

void main() {
  TweetCache tweetCache;

  Logger.root.clearListeners();

  setUp(() {
//    tweetCache = TweetCache();
  });

  test("checkCacheForTweets no cached data found", () async {
//    MockCacheDirectoryService mockCacheDirectoryService =
//        MockCacheDirectoryService();
//    tweetCache.directoryService = mockCacheDirectoryService;
//
//    when(mockCacheDirectoryService.listFiles(any))
//        .thenAnswer((_) => Future.value([]));
//    AppConfiguration().twitterSession = TwitterSession.fromMap({"userId": "1"});
//
//    List<Tweet> actualResult = await tweetCache.checkCacheForTweets();
//    expect(actualResult.length, 0);
  });

  test("checkCacheForTweets cached data found", () async {
//    MockCacheDirectoryService mockCacheDirectoryService =
//        MockCacheDirectoryService();
//    tweetCache.cacheDirService = mockCacheDirectoryService;
//
//    File file1 = File("test/target/unit_test_file1.json");
//    File file2 = File("test/target/unit_test_file2.json");
//    file1.createSync(recursive: true);
//    file2.createSync(recursive: true);
//
//    file1.writeAsStringSync('{}');
//    file2.writeAsStringSync('{}');
//
//    when(mockCacheDirectoryService.listFiles("tweets/1"))
//        .thenAnswer((_) => Future.value([file1, file2]));
//
//    AppConfiguration().initForUnitTesting();
//    AppConfiguration().twitterSession = TwitterSession.fromMap({"userId": "1"});
//    AppConfiguration()
//        .applicationConfig
//        .cacheConfiguration
//        .tweetCacheTimeInHours = 1;
//
//    List<Tweet> actualResult = await tweetCache.checkCacheForTweets();
//    expect(actualResult.length, 2);
  });

  test("checkCacheForTweets get bucket name", () async {
//    MockCacheDirectoryService mockCacheDirectoryService =
//        MockCacheDirectoryService();
//    tweetCache.cacheDirService = mockCacheDirectoryService;
//
//    AppConfiguration().initForUnitTesting();
//    AppConfiguration().twitterSession = TwitterSession.fromMap({"userId": "1"});
//    expect(tweetCache.currentBucketName, "tweets/1");
  });
}

class MockDirectoryService extends Mock implements DirectoryService {}
