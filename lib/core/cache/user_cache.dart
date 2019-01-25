import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class UserCache {
  UserCache({
    @required this.directoryService,
  });

  final DirectoryService directoryService;

  static final Logger _log = Logger("UserCache");

  /// The sub directory where the files are stored.
  String bucket = "users/";

  /// Caches the [user].
  ///
  /// If a [User] with the same [User.id] and [User.screenName] already exists
  /// it will be overridden.
  void cacheUser(User user) {
    String fileName = "${user.id}.json";

    directoryService.createFile(
      bucket: bucket,
      name: fileName,
      content: jsonEncode(user.toJson()),
    );
  }

  /// Gets the cached [User] with the [id].
  ///
  /// Returns null if no user with that [User.id] is found in the cache.
  User getCachedUser(String id) {
    _log.fine("get cached user for id: $id");

    String fileName = "$id.json";

    File file = directoryService.getFile(
      bucket: bucket,
      name: fileName,
    );

    if (file != null) {
      _log.fine("found user in cache");
      return User.fromJson(jsonDecode(file.readAsStringSync()));
    } else {
      _log.fine("user not in cache");
      return null;
    }
  }
}
