import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:logging/logging.dart';

class UserCache {
  final Logger log = Logger("UserCache");

  static UserCache _instance = UserCache._();
  factory UserCache() => _instance;
  UserCache._();

  /// The sub directory where the files are stored.
  String bucket = "users/";

  /// Caches the [user].
  ///
  /// If a [User] with the same [User.id] and [User.screenName] already exists
  /// it will be overridden.
  void cacheUser(User user) {
    String fileName = "${user.id}_${user.screenName.toLowerCase()}.json";

    DirectoryService().createFile(
      bucket: bucket,
      name: fileName,
      content: jsonEncode(user.toJson()),
    );
  }

  /// Gets the cached [User] with the [id] or [screenName].
  ///
  /// Returns null if no user with that [User.id] or [User.screenName] is found
  /// in the cache.
  User getCachedUser({
    String id,
    String screenName,
  }) {
    assert(id != null || screenName != null);

    log.fine("get cached user for id: $id, screenName: $screenName");

    List<File> cachedUsers = DirectoryService().listFiles(bucket: bucket);

    log.fine("found ${cachedUsers.length} cached users");

    File file = cachedUsers.firstWhere((file) {
      try {
        // parse the file name from the path
        String name = file.path.substring(file.path.lastIndexOf("/") + 1);

        // parse the id and screenName from the file name
        String fileId = name.substring(0, name.indexOf("_"));
        String fileScreenName = name.substring(
          name.indexOf("_") + 1,
          name.lastIndexOf("."),
        );

        // if either the id or the name corresponds to the cached file
        return id == fileId ||
            screenName.toLowerCase() == fileScreenName.toLowerCase();
      } on Error {
        return false;
      }
    }, orElse: () => null);

    if (file != null) {
      log.fine("found user in cache");
      return User.fromJson(jsonDecode(file.readAsStringSync()));
    } else {
      log.fine("user not in cache");
      return null;
    }
  }
}
