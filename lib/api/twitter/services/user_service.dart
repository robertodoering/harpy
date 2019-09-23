import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/paginated_users.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';

class UserService {
  final TwitterClient twitterClient = app<TwitterClient>();

  static final Logger _log = Logger("UserService");

  /// Returns the [User] corresponding to the [id].
  Future<User> getUserDetails({
    @required String id,
  }) async {
    _log.fine("getting user details");

    final params = <String, String>{
      "include_entities": "true",
      "user_id": id,
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/users/show.json",
          params: params,
        )
        .then(
          (response) => compute<String, User>(
            _handleUserDetailsResponse,
            response.body,
          ),
        );
  }

  /// Returns a list of [User]s that match the [query].
  ///
  /// The results are paginated with one page containing 20 [User] objects.
  ///
  /// If the [page] is higher than the max possible page, the last 20 [User]
  /// objects are returned.
  /// Therefore, to know if the last page has been reached, it should be
  /// verified that a response only contains new [User] objects.
  Future<List<User>> searchUsers({
    @required String query,
    int page = 1,
  }) async {
    _log.fine("searching users for query $query");

    if (query?.isNotEmpty != true) {
      // the query can not be null or empty
      return null;
    }

    final params = <String, String>{
      "q": query,
      "page": "$page",
      "count": "20",
      "include_entities": "true",
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/users/search.json",
          params: params,
        )
        .then(
          (response) => compute<String, List<User>>(
            _handleSearchUsersResponse,
            response.body,
          ),
        );
  }

  /// Follows (friends) the [User] with the [id].
  Future<void> createFriendship(String id) async {
    _log.fine("create friendship");

    return twitterClient.post(
      "https://api.twitter.com/1.1/friendships/create.json",
      params: {"user_id": id},
    );
  }

  /// Unfollows the [User] with the [id].
  Future<void> destroyFriendship(String id) async {
    _log.fine("destroy friendship");

    return twitterClient.post(
      "https://api.twitter.com/1.1/friendships/destroy.json",
      params: {"user_id": id},
    );
  }

  /// Returns a paginated collection of [User]s for users following the user
  /// with the [id].
  ///
  /// The [cursor] determines what page is returned. `-1` is the first page.
  /// When [PaginatedUsers.nextCursor] is `0`, the last page has been reached.
  Future<PaginatedUsers> getFollowers({
    @required String id,
    int cursor = -1,
  }) async {
    _log.fine("get followers for $id");

    final params = <String, String>{
      "include_entities": "true",
      "user_id": id,
      "cursor": "$cursor",
      "count": "100", // max 200
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/followers/list.json",
          params: params,
        )
        .then(
          (response) => compute<String, PaginatedUsers>(
            _handlePaginatedUsersResponse,
            response.body,
          ),
        );
  }

  /// Returns a paginated collection of [User]s for every user the user with
  /// the [id] is following (otherwise known as their "friends").
  ///
  /// The [cursor] determines what page is returned. `-1` is the first page.
  /// When [PaginatedUsers.nextCursor] is `0`, the last page has been reached.
  Future<PaginatedUsers> getFollowing({
    @required String id,
    int cursor = -1,
  }) async {
    _log.fine("get following users for $id");

    final params = <String, String>{
      "include_entities": "true",
      "user_id": id,
      "cursor": "$cursor",
      "count": "100", // max 200
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/friends/list.json",
          params: params,
        )
        .then(
          (response) => compute<String, PaginatedUsers>(
            _handlePaginatedUsersResponse,
            response.body,
          ),
        );
  }
}

User _handleUserDetailsResponse(String body) {
  return User.fromJson(jsonDecode(body));
}

List<User> _handleSearchUsersResponse(String body) {
  return mapJson<User>(body, (json) => User.fromJson(json)) ?? [];
}

PaginatedUsers _handlePaginatedUsersResponse(String body) {
  return PaginatedUsers.fromJson(jsonDecode(body));
}
