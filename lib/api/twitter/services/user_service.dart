import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/misc/json_mapper.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class UserService {
  UserService({
    @required this.twitterClient,
    @required this.userCache,
  })  : assert(twitterClient != null),
        assert(userCache != null);

  final TwitterClient twitterClient;
  final UserCache userCache;

  static final Logger _log = Logger("UserService");

  /// Returns the [User] corresponding to the [id] or [screenName].
  Future<User> getUserDetails({
    String id,
    String screenName,
  }) async {
    _log.fine("getting user details");

    final params = {"include_entities": "true"};
    if (id != null) params["user_id"] = id;
    if (screenName != null) params["screen_name"] = screenName;

    final response = await twitterClient.get(
      "https://api.twitter.com/1.1/users/show.json",
      params: params,
    );

    if (response.statusCode == 200) {
      _log.fine("got 200 response");
      User user = mapJson<User>(response.body, (json) => User.fromJson(json));

      userCache.cacheUser(user);

      return user;
    } else {
      _log.warning("response not 200");
      return Future.error(response.statusCode);
    }
  }

  /// Follows (friends) the [User] with the [id].
  Future<bool> createFriendship(String id) async {
    _log.fine("create friendship");

    final params = {"user_id": id};

    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/friendships/create.json",
      params: params,
    );

    if (response.statusCode == 200) {
      _log.fine("got 200 response: created friendship");
      return true;
    } else {
      _log.warning("response not 200");
      return Future.error(response.statusCode);
    }
  }

  /// Unfollows the [User] with the [id].
  Future<void> destroyFriendship(String id) async {
    _log.fine("destroy friendship");

    final params = {"user_id": id};

    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/friendships/destroy.json",
      params: params,
    );

    if (response.statusCode == 200) {
      _log.fine("got 200 response: destroyed friendship");
      return true;
    } else {
      _log.warning("response not 200");
      return Future.error(response.statusCode);
    }
  }
}
