import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/database_service.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  setUp(() {
    app..registerLazySingleton<DatabaseService>(() => MockDatabaseService());
  });

  tearDown(app.reset);

  test("Tweet json gets recorded", () async {
    final database = TweetDatabase();

    final tweet = Tweet()..id = 1337;
    final tweetJson = toPrimitiveJson(tweet.toJson());

    final bool result = await database.recordTweet(tweet);

    expect(result, true);

    verify(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: anyNamed("store"),
      key: tweet.id,
      data: tweetJson,
    ));
  });

  test("Exception during tweet record fails gracefully", () async {
    final database = TweetDatabase();

    final tweet = Tweet()..id = 1337;
    final tweetJson = toPrimitiveJson(tweet.toJson());

    when(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: anyNamed("store"),
      key: tweet.id,
      data: tweetJson,
    )).thenThrow(Exception("Test exception"));

    final bool result = await database.recordTweet(tweet);

    expect(result, false);
  });

  test("Tweet list json gets recorded", () async {
    final database = TweetDatabase();

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final keys = [1337, 69, 42];

    final tweetJsonList =
        tweets.map((tweet) => toPrimitiveJson(tweet.toJson())).toList();

    final bool result = await database.recordTweetList(tweets);

    expect(result, true);

    verify(app<DatabaseService>().transaction(
      path: anyNamed("path"),
      store: anyNamed("store"),
      keys: keys,
      dataList: tweetJsonList,
    ));
  });

  test(
      "Exception during Tweet list record fails gracefully and "
      "returns false", () async {
    final database = TweetDatabase();

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final keys = [1337, 69, 42];

    final tweetJsonList =
        tweets.map((tweet) => toPrimitiveJson(tweet.toJson())).toList();

    when(app<DatabaseService>().transaction(
      path: anyNamed("path"),
      store: anyNamed("store"),
      keys: keys,
      dataList: tweetJsonList,
    )).thenThrow(Exception("Test exception"));

    final bool result = await database.recordTweetList(tweets);

    expect(result, false);
  });

  test("Finds and decodes list of tweets from id", () async {
    final database = TweetDatabase();

    final tweets = [
      Tweet()..id = 1337,
      Tweet()..id = 69,
      Tweet()..id = 42,
    ];

    final tweetIds = [1337, 69, 42];

    final tweetJsonList =
        tweets.map((tweet) => toPrimitiveJson(tweet.toJson())).toList();

    when(app<DatabaseService>().find(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(tweetJsonList));

    final foundTweets = await database.findTweets(tweetIds);

    expect(foundTweets, tweets);
  });

  test("Returns empty list if tweets can't be found", () async {
    final database = TweetDatabase();

    when(app<DatabaseService>().find(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value([]));

    final foundTweets = await database.findTweets([1337, 69, 42]);

    expect(foundTweets, <Tweet>[]);
  });

  test("Returns empty list if finding tweet lists throws exception", () async {
    final database = TweetDatabase();

    final tweetIds = [1337, 69, 42];

    when(app<DatabaseService>().find(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenThrow(Exception("Test exception"));

    final foundTweets = await database.findTweets(tweetIds);

    expect(foundTweets, <Tweet>[]);
  });

  test("Recorded tweets get limited to targetAmount when the limit is reached",
      () async {
    final database = TweetDatabase();

    final storedTweetValues = [
      {"id": 1337},
      {"id": 69},
      {"id": 42},
      {"id": 29},
    ];

    when(app<DatabaseService>().find(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(storedTweetValues));

    final bool result = await database.limitRecordedTweets(
      limit: 4,
      targetAmount: 2,
    );

    expect(result, true);

    verify(app<DatabaseService>().drop(name: anyNamed("name")));

    verify(app<DatabaseService>().transaction(
      path: anyNamed("path"),
      store: anyNamed("store"),
      keys: anyNamed("keys"),
      dataList: [
        {"id": 1337},
        {"id": 69}
      ],
    ));
  });

  test(
      "Recorded tweets don't get limited if target amount has not been "
      "reached", () async {
    final database = TweetDatabase();

    final storedTweetValues = [
      {"id": 1337},
      {"id": 69},
    ];

    when(app<DatabaseService>().find(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(storedTweetValues));

    final bool result = await database.limitRecordedTweets(
      limit: 4,
      targetAmount: 2,
    );

    expect(result, false);

    verifyNever(app<DatabaseService>().drop(name: anyNamed("name")));

    verifyNever(app<DatabaseService>().transaction(
      path: anyNamed("path"),
      store: anyNamed("store"),
      keys: anyNamed("keys"),
      dataList: anyNamed("dataList"),
    ));
  });
}
