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

  /// Returns the [User] corresponding to the [id].
  Future<User> getUserDetails({
    String id,
  }) async {
    _log.fine("getting user details");

    final params = {
      "include_entities": "true",
      "user_id": id,
    };

    return await twitterClient
        .get(
      "https://api.twitter.com/1.1/users/show.json",
      params: params,
    )
        .then((response) {
      User user = mapJson<User>(response.body, (json) => User.fromJson(json));

      userCache.cacheUser(user);

      return user;
    });
  }

  /// Follows (friends) the [User] with the [id].
  Future<void> createFriendship(String id) async {
    _log.fine("create friendship");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/friendships/create.json",
      params: {"user_id": id},
    );
  }

  /// Unfollows the [User] with the [id].
  Future<void> destroyFriendship(String id) async {
    _log.fine("destroy friendship");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/friendships/destroy.json",
      params: {"user_id": id},
    );
  }
}
