import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/database.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores [User] objects in a database.
class UserDatabase extends HarpyDatabase {
  UserDatabase({
    StoreRef<int, Map<String, dynamic>> store,
  }) : store = store ?? intMapStoreFactory.store();

  final StoreRef<int, Map<String, dynamic>> store;

  @override
  String get name => "user_db/$subDirectory";

  static final Logger _log = Logger("UserDatabase");

  /// Records the [user] in the user database.
  ///
  /// Overrides any [User] with the same [User.id].
  Future<bool> recordUser(User user) async {
    _log.fine("recording user with id ${user.id}");

    try {
      final Map<String, dynamic> userJson =
          await compute<User, Map<String, dynamic>>(
        _handleUserSerialization,
        user,
      );

      await store.record(user.id).put(db, userJson);

      _log.fine("user recorded");

      return true;
    } catch (e, st) {
      _log.severe("error while trying to record user", e, st);
      return false;
    }
  }

  /// Finds the cached [User] with the [userId].
  ///
  /// Returns `null` if the user can't be found.
  Future<User> findUser(int userId) async {
    _log.fine("finding user with id $userId");

    try {
      final record = await store.findFirst(
        db,
        finder: Finder(filter: Filter.byKey(userId)),
      );

      if (record != null) {
        final User user =
            await compute<RecordSnapshot<int, Map<String, dynamic>>, User>(
          _handleUserDeserialization,
          record,
        );

        _log.fine("found user ${user.name}");

        return user;
      }
    } catch (e, st) {
      _log.severe("exception while trying to find user", e, st);
    }

    return null;
  }
}

Map<String, dynamic> _handleUserSerialization(User user) {
  return toPrimitiveJson(user.toJson());
}

User _handleUserDeserialization(
  RecordSnapshot<int, Map<String, dynamic>> record,
) {
  return User.fromJson(record.value);
}
