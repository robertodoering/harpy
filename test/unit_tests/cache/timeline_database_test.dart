import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/database_service.dart';
import 'package:harpy/core/cache/timeline_database.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/harpy.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockTweetDatabase extends Mock implements TweetDatabase {}

void main() {
  setUp(() {
    app
      ..registerLazySingleton<DatabaseService>(() => MockDatabaseService())
      ..registerLazySingleton<TweetDatabase>(() => MockTweetDatabase());
  });

  tearDown(app.reset);

  test("Home timeline ids get recorded with key 'ids' in homeTimelineStore",
      () async {
    final database = TimelineDatabase();

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final tweetIds = [1337, 69, 42];

    final bool result = await database.recordHomeTimelineIds(tweets);

    expect(result, true);

    verify(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: database.homeTimelineStore,
      key: "ids",
      data: tweetIds,
    ));
  });

  test(
      "Exception during home timeline record fails gracefully and returns "
      "false", () async {
    final database = TimelineDatabase();

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final tweetIds = [1337, 69, 42];

    when(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: database.homeTimelineStore,
      key: "ids",
      data: tweetIds,
    )).thenThrow(Exception("Test exception"));

    final bool result = await database.recordHomeTimelineIds(tweets);

    expect(result, false);
  });

  test(
      "User timeline ids get recorded with user id as key in "
      "userTimelineStore", () async {
    final database = TimelineDatabase();

    final user = User()..id = 22;

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final tweetIds = [1337, 69, 42];

    final bool result = await database.recordUserTimelineIds(user.id, tweets);

    expect(result, true);

    verify(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: database.userTimelineStore,
      key: user.id,
      data: tweetIds,
    ));
  });

  test(
      "Exception during user timeline record fails gracefully and returns "
      "false", () async {
    final database = TimelineDatabase();

    final user = User()..id = 22;

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final tweetIds = [1337, 69, 42];

    when(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: database.userTimelineStore,
      key: user.id,
      data: tweetIds,
    )).thenThrow(Exception("Test exception"));

    final bool result = await database.recordUserTimelineIds(user.id, tweets);

    expect(result, false);
  });

  test(
      "Finding home timeline tweets retrieves home timeline ids and calls "
      "findTweets in TweetService", () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.homeTimelineStore,
    )).thenAnswer((_) => Future.value(<dynamic>[1337, 69, 42]));

    await database.findHomeTimelineTweets();

    verify(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.homeTimelineStore,
    ));

    verify(app<TweetDatabase>().findTweets([1337, 69, 42]));
  });

  test(
      "Finding no home timeline ids returns empty list and does not call the "
      "TweetService", () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.homeTimelineStore,
    )).thenAnswer((_) => Future.value(<dynamic>[]));

    final foundTweets = await database.findHomeTimelineTweets();

    expect(foundTweets, <Tweet>[]);

    verify(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.homeTimelineStore,
    ));

    verifyNever(app<TweetDatabase>().findTweets(any));
  });

  test("Finding home timeline ids fails gracefully and returns an empty list",
      () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.homeTimelineStore,
    )).thenThrow(Exception("Test exception"));

    final foundTweets = await database.findHomeTimelineTweets();

    expect(foundTweets, <Tweet>[]);
  });

  test(
      "Exception when finding user timeline tweets retrieves user timeline ids "
      "and calls findTweets in TweetService", () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.userTimelineStore,
    )).thenAnswer((_) => Future.value(<dynamic>[1337, 69, 42]));

    await database.findUserTimelineTweets(22);

    verify(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.userTimelineStore,
    ));

    verify(app<TweetDatabase>().findTweets([1337, 69, 42]));
  });

  test(
      "Finding no user timeline ids returns empty list and does not call the "
      "TweetService", () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.userTimelineStore,
    )).thenAnswer((_) => Future.value(<dynamic>[]));

    final foundTweets = await database.findUserTimelineTweets(22);

    expect(foundTweets, <Tweet>[]);

    verify(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.userTimelineStore,
    ));

    verifyNever(app<TweetDatabase>().findTweets(any));
  });

  test(
      "Exception when finding user timeline ids fails gracefully and returns "
      "an empty list", () async {
    final database = TimelineDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      finder: anyNamed("finder"),
      store: database.userTimelineStore,
    )).thenThrow(Exception("Test exception"));

    final foundTweets = await database.findUserTimelineTweets(22);

    expect(foundTweets, <Tweet>[]);
  });
}
