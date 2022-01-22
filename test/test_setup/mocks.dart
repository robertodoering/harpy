import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHarpyPreferences extends HarpyPreferences {
  MockHarpyPreferences() {
    SharedPreferences.setMockInitialValues({});
  }
}

class MockAppConfig extends EnvConfig {
  const MockAppConfig({
    required this.twitterConsumerKey,
    required this.twitterConsumerSecret,
  });

  @override
  final String twitterConsumerKey;

  @override
  final String twitterConsumerSecret;
}

class MockHomeTimelineCubit extends Mock implements HomeTimelineCubit {
  MockHomeTimelineCubit(TimelineState initialState) {
    when(() => state).thenReturn(initialState);
  }
}

class MockMentionsTimelineCubit extends Mock implements MentionsTimelineCubit {
  MockMentionsTimelineCubit(TimelineState<bool> initialState) {
    when(() => state).thenReturn(initialState);
  }
}

class MockTimelineFilterCubit extends Mock implements TimelineFilterCubit {
  MockTimelineFilterCubit(TimelineFilterState initialState) {
    when(() => state).thenReturn(initialState);
    when(() => stream).thenAnswer((_) => Stream.value(initialState));
    when(close).thenAnswer((_) async {});
  }
}

class MockHarpyNavigator extends Mock implements HarpyNavigator {}

class MockMessageService extends Mock implements MessageService {}

class MockHarpyInfo extends Mock implements HarpyInfo {}

class MockTranslationService extends Mock implements TranslationService {}

class MockConnectivityService extends Mock implements ConnectivityService {
  MockConnectivityService() {
    when(() => mobile).thenReturn(false);
    when(() => wifi).thenReturn(true);
  }
}

// twitter api

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
