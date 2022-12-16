import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_twitter_api/twitter_api.dart' as v1;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

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

class MockTwitterApiV1 extends Mock implements v1.TwitterApi {
  @override
  final userService = MockUserServiceV1();

  @override
  final tweetService = MockTweetServiceV1();

  @override
  final tweetSearchService = MockTweetSearchServiceV1();

  @override
  final timelineService = MockTimelineServiceV1();

  @override
  final mediaService = MockMediaServiceV1();

  @override
  final listsService = MockListsServiceV1();

  @override
  final directMessagesService = MockDirectMessagesServiceV1();

  @override
  final trendsService = MockTrendsServiceV1();
}

class MockUserServiceV1 extends Mock implements v1.UserService {}

class MockTweetServiceV1 extends Mock implements v1.TweetService {}

class MockTweetSearchServiceV1 extends Mock implements v1.TweetSearchService {}

class MockTimelineServiceV1 extends Mock implements v1.TimelineService {}

class MockMediaServiceV1 extends Mock implements v1.MediaService {}

class MockListsServiceV1 extends Mock implements v1.ListsService {}

class MockDirectMessagesServiceV1 extends Mock
    implements v1.DirectMessagesService {}

class MockTrendsServiceV1 extends Mock implements v1.TrendsService {}

class MockTwitterApiV2 extends Mock implements v2.TwitterApi {
  @override
  final tweets = MockTweetsServiceV2();

  @override
  final users = MockUsersServiceV2();

  @override
  final spaces = MockSpacesServiceV2();

  @override
  final lists = MockListsServiceV2();

  @override
  final media = MockMediaServiceV2();

  @override
  final directMessages = MockDirectMessagesServiceV2();

  @override
  final geo = MockGeoServiceV2();

  @override
  final trends = MockTrendsServiceV2();

  @override
  final compliance = MockComplianceServiceV2();
}

class MockListsServiceV2 extends Mock implements v2.ListsService {}

class MockTweetsServiceV2 extends Mock implements v2.TweetsService {}

class MockUsersServiceV2 extends Mock implements v2.UsersService {}

class MockSpacesServiceV2 extends Mock implements v2.SpacesService {}

class MockMediaServiceV2 extends Mock implements v2.MediaService {}

class MockDirectMessagesServiceV2 extends Mock
    implements v2.DirectMessagesService {}

class MockGeoServiceV2 extends Mock implements v2.GeoService {}

class MockTrendsServiceV2 extends Mock implements v2.TrendsService {}

class MockComplianceServiceV2 extends Mock implements v2.ComplianceService {}
