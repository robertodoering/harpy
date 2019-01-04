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
  /// If a [User] with the same [User.id] already exists it will be overridden.
  void cacheUser(User user) {
    String fileName = "${user.id}.json";

    DirectoryService().createFile(
      bucket: bucket,
      name: fileName,
      content: jsonEncode(user.toJson()),
    );
  }

  /// Gets the cached [User] with the [id].
  ///
  /// Returns null if no user with that [User.id] is found in the cache.
  User getCachedUser(String id) {
    File file = DirectoryService().getFile(
      bucket: bucket,
      name: "$id.json",
    );

    return file != null
        ? User.fromJson(jsonDecode(file.readAsStringSync()))
        : null;
  }
}
