import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockStore extends Mock implements StoreRef<int, Map<String, dynamic>> {}

class MockRecord extends Mock implements RecordRef<int, Map<String, dynamic>> {}

class MockRecordSnapshot extends Mock
    implements RecordSnapshot<int, Map<String, dynamic>> {}

void main() {
  test("Tweet json gets recorded", () async {
    final store = MockStore();
    final mockRecord = MockRecord();

    final database = TweetDatabase(store: store);

    final tweet = Tweet()..id = 1337;

    final tweetJson = tweet.toJson();

    when(store.record(any)).thenReturn(mockRecord);

    final bool recorded = await database.recordTweet(tweet);

    expect(recorded, true);

    verify(store.record(1337));
    verify(mockRecord.put(any, tweetJson));
  });

  test("Finds and decodes tweet", () async {
    final store = MockStore();
    final mockRecordSnapshots = [MockRecordSnapshot(), MockRecordSnapshot()];

    final database = TweetDatabase(store: store);

    final tweets = <Tweet>[
      Tweet()..id = 69,
      Tweet()..id = 1337,
    ];

    when(store.find(
      any,
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(mockRecordSnapshots));

    when(mockRecordSnapshots[0].value).thenReturn(tweets[0].toJson());
    when(mockRecordSnapshots[1].value).thenReturn(tweets[1].toJson());

    final List<Tweet> foundTweets = await database.findTweets([69, 1337]);

    expect(foundTweets, tweets);
  });
}
