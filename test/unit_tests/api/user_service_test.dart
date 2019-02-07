import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTwitterClient extends Mock implements TwitterClient {}

class MockUserCache extends Mock implements UserCache {}

void main() async {
  UserService _userService;
  TwitterClient _mockTwitterClient;
  UserCache _mockUserCache;

  setUp(() {
    _mockUserCache = MockUserCache();
    _mockTwitterClient = MockTwitterClient();

    _userService = UserService(
      twitterClient: _mockTwitterClient,
      userCache: _mockUserCache,
    );
  });

  test("chek that request tries to store json on device and returns user",
      () async {
    String userId = "123";
    when(
      _mockTwitterClient.get(
        any,
        params: anyNamed("params"),
      ),
    ).thenAnswer(
      (_) => Future.value(
            Response.bytes('{"id" : $userId}'.codeUnits, 200),
          ),
    );

    User result = await _userService.getUserDetails(id: userId);

    verify(
      _mockUserCache.cacheUser(any),
    );

    expect(result.id, equals(int.parse(userId)));
  });

  test("check params for getUserDetails", () async {
    String userId = "123";
    String screenName = "iBims";

    when(
      _mockTwitterClient.get(
        any,
        params: anyNamed(
          "params",
        ),
      ),
    ).thenAnswer(
      (_) => Future.value(
            Response("{}", 200),
          ),
    );

    await _userService.getUserDetails(id: userId, screenName: screenName);

    verify(
      _mockTwitterClient.get(
        "https://api.twitter.com/1.1/users/show.json",
        params: argThat(
          equals(
            {
              "include_entities": "true",
              "user_id": userId,
              "screen_name": screenName
            },
          ),
          named: "params",
        ),
      ),
    );
  });

  test("check that if status code not 200 error is thrown", () async {
    String userId = "123";

    when(
      _mockTwitterClient.get(
        any,
        params: anyNamed("params"),
      ),
    ).thenAnswer(
      (_) => Future.value(
            Response.bytes('{"id" : $userId}'.codeUnits, 500),
          ),
    );

    expect(_userService.getUserDetails(id: userId), throwsA(anything));
  });
}
