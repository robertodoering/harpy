import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';

class MockDirectoryService extends Mock implements DirectoryService {}

class MockFile extends Mock implements File {}

void main() {
  Logger.root.clearListeners();

  UserTimelineCache _userTimeLineCache;
  DirectoryService _mockedDirService;

  setUp(() {
    _mockedDirService = MockDirectoryService();
    _userTimeLineCache = UserTimelineCache(directoryService: _mockedDirService);
  });

  test("verify cache tweet tries to create a file within correct bucket",
      () async {
    _userTimeLineCache.initLoggedInUser("1337");
    _userTimeLineCache.cacheTweet(Tweet.mock());

    verify(_mockedDirService.createFile(
        bucket: 'tweets/user_timeline/1337',
        name: anyNamed("name"),
        content: anyNamed("content")));
  });

  test("check tries to update existing tweet if exist", () async {
    _userTimeLineCache.initLoggedInUser("1337");

    when(_mockedDirService.getFile(
            bucket: anyNamed("bucket"), name: anyNamed("name")))
        .thenAnswer((invoke) => File("ibims.json"));

    _userTimeLineCache.updateTweet(Tweet.mock());

    verify(_mockedDirService.createFile(
        bucket: anyNamed("bucket"),
        name: anyNamed("name"),
        content: anyNamed("content")));
  });

  test("check dont do anything when try to update tweet that doesnt exist",
      () async {
    _userTimeLineCache.initLoggedInUser("1337");

    when(_mockedDirService.getFile(
            bucket: anyNamed("bucket"), name: anyNamed("name")))
        .thenAnswer((invoke) => null);

    _userTimeLineCache.updateTweet(Tweet.mock());

    verifyNever(_mockedDirService.createFile(
        bucket: anyNamed("bucket"),
        name: anyNamed("name"),
        content: anyNamed("content")));
  });

  test("check bucket name for loggedIn user is correct", () async {
    _userTimeLineCache.initLoggedInUser("1337");
    expect(_userTimeLineCache.bucket, "tweets/user_timeline/1337");
  });

  test("check bucket name for loggedIn user subbucket is correct", () async {
    _userTimeLineCache.initLoggedInUser("1337");
    _userTimeLineCache.data.userId = "iBimbs";

    expect(_userTimeLineCache.bucket, "tweets/user_timeline/1337/iBimbs");
  });

  test("check tries to read correct file for tweet id", () async {
    _userTimeLineCache.initLoggedInUser("1337");
    File mockFile = MockFile();

    when(mockFile.readAsStringSync()).thenReturn("{}");

    when(_mockedDirService.getFile(
            bucket:
                argThat(equals("tweets/user_timeline/1337"), named: "bucket"),
            name: argThat(equals("1234.json"), named: "name")))
        .thenAnswer((invoke) => mockFile);

    _userTimeLineCache.getTweet("1234");

    verify(mockFile.readAsStringSync());
    verify(_mockedDirService.getFile(
            bucket:
                argThat(equals("tweets/user_timeline/1337"), named: "bucket"),
            name: argThat(equals("1234.json"), named: "name")))
        .called(1);
  });

  test("check getCachedTweets tries to read to list files", () {
    _userTimeLineCache.initLoggedInUser("1337");
    _userTimeLineCache.data.userId = "ibimbs";

    when(
      _mockedDirService.listFiles(
        bucket: argThat(
          equals("tweets/user_timeline/1337/ibimbs"),
          named: "bucket",
        ),
        extension: ".json",
      ),
    ).thenAnswer((_) {
      List<File> list = [
        MockFile(),
        MockFile(),
      ];
      int index = 4;
      list.forEach((file) {
        when(file.readAsStringSync()).thenReturn('{"id": $index}');
        index++;
      });

      return list;
    });

    List<Tweet> tweets = _userTimeLineCache.getCachedTweets();

    verify(
      _mockedDirService.listFiles(
        bucket: argThat(
          equals("tweets/user_timeline/1337/ibimbs"),
          named: "bucket",
        ),
        extension: ".json",
      ),
    );

    expect(tweets.first.id, 5);
  });

  test("check update cached tweets update multiple tweet files", () async {
    _userTimeLineCache.initLoggedInUser("12341");

    List<Tweet> tweets = [
      Tweet.mock()..id = 25,
      Tweet.mock()..id = 125,
    ];

    when(
      _mockedDirService.getFile(
        bucket: anyNamed("bucket"),
        name: anyNamed("name"),
      ),
    ).thenAnswer((invoke) {
      String argument = invoke.namedArguments[Symbol("name")].toString();
      String tweetId = argument.split(".").first;

      File file = MockFile();

      when(file.readAsStringSync()).thenAnswer((_) {
        Tweet tweet = tweets.firstWhere(
          (tweet) => tweet.id == int.parse(tweetId),
        );
        return jsonEncode(tweet);
      });

      return file;
    });

    when(
      _mockedDirService.listFiles(
        bucket: anyNamed("bucket"),
      ),
    ).thenReturn([]);

    _userTimeLineCache.updateCachedTweets(tweets);

    verify(
      _mockedDirService.getFile(
        bucket: anyNamed("bucket"),
        name: anyNamed("name"),
      ),
    ).called(2);
  });
}
