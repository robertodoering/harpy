import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHarpyPreferences extends HarpyPreferences {
  MockHarpyPreferences() {
    SharedPreferences.setMockInitialValues({});
  }
}

class MockAppConfig extends AppConfig {
  const MockAppConfig({
    required this.twitterConsumerKey,
    required this.twitterConsumerSecret,
  });

  @override
  final String twitterConsumerKey;

  @override
  final String twitterConsumerSecret;
}

class MockHarpyNavigator extends Mock implements HarpyNavigator {}

class MockMessageService extends Mock implements MessageService {}

class MockTwitterApiClient extends Mock implements AbstractTwitterClient {}

class MockDirectMessagesService extends Mock implements DirectMessagesService {}

class MockListsService extends Mock implements ListsService {}

class MockMediaService extends Mock implements MediaService {}

class MockTimelineService extends Mock implements TimelineService {}

class MockTrendsService extends Mock implements TrendsService {}

class MockTweetSearchService extends Mock implements TweetSearchService {}

class MockTweetService extends Mock implements TweetService {}

class MockUserService extends Mock implements UserService {}

class MockTwitterApi implements TwitterApi {
  MockTwitterApi();

  @override
  final client = MockTwitterApiClient();

  @override
  final directMessagesService = MockDirectMessagesService();

  @override
  final listsService = MockListsService();

  @override
  final mediaService = MockMediaService();

  @override
  final timelineService = MockTimelineService();

  @override
  final trendsService = MockTrendsService();

  @override
  final tweetSearchService = MockTweetSearchService();

  @override
  final tweetService = MockTweetService();

  @override
  final userService = MockUserService();
}
