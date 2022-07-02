import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:mocktail/mocktail.dart';

class MockApplication extends Mock implements Application {
  MockApplication() {
    when(initialize).thenAnswer((_) async {});
  }
}

class MockConnectivityNotifier extends StateNotifier<ConnectivityResult>
    with Mock
    implements ConnectivityNotifier {
  MockConnectivityNotifier([ConnectivityResult? state])
      : super(state ?? ConnectivityResult.mobile) {
    when(initialize).thenAnswer((_) async {});
  }
}

class MockRouter extends Mock implements GoRouter {}

class MockTwitterApi extends Mock implements TwitterApi {
  @override
  final userService = MockUserService();

  @override
  final tweetService = MockTweetService();

  @override
  final tweetSearchService = MockTweetSearchService();

  @override
  final timelineService = MockTimelineService();

  @override
  final mediaService = MockMediaService();

  @override
  final listsService = MockListsService();

  @override
  final directMessagesService = MockDirectMessagesService();

  @override
  final trendsService = MockTrendsService();
}

class MockUserService extends Mock implements UserService {}

class MockTweetService extends Mock implements TweetService {}

class MockTweetSearchService extends Mock implements TweetSearchService {}

class MockTimelineService extends Mock implements TimelineService {}

class MockMediaService extends Mock implements MediaService {}

class MockListsService extends Mock implements ListsService {}

class MockDirectMessagesService extends Mock implements DirectMessagesService {}

class MockTrendsService extends Mock implements TrendsService {}
