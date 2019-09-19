import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Uses a [Database] to store persistent data in the cache directory on the
/// device.
///
/// Database operations are run in an isolate using [compute] to avoid the
/// risk of skipping frames since they can take multiple milliseconds to
/// complete.
class DatabaseService {
  static final Logger _log = Logger("DatabaseService");

  /// Deletes the database directory for [name] in an isolate.
  Future<bool> drop({
    @required String name,
  }) async {
    final directory = await getTemporaryDirectory();

    final path = "${directory.path}/database/$name/";

    _log.fine("deleting $path");

    return compute<String, bool>(_isolateDrop, path);
  }

  /// Records the [data] associated to the [key] in the [store] for this
  /// database in an isolate.
  ///
  /// When recording a list of data, [transaction] should be used instead.
  Future<dynamic> record({
    @required String path,
    @required StoreRef store,
    @required dynamic key,
    @required dynamic data,
  }) async {
    final Map<String, dynamic> message = {
      "path": path,
      "store": store,
      "key": key,
      "data": data,
    };

    assert(message["path"] is String);
    assert(message["store"] is StoreRef);
    assert(message["key"] != null);
    assert(message["data"] != null);

    _log.fine("recording data");

    return compute<Map<String, dynamic>, dynamic>(_isolateRecord, message);
  }

  /// Creates a transaction to record the [dataList] associated to their [keys]
  /// in the [store] for this database in an isolate.
  ///
  /// [keys] must be equal in length to the [dataList].
  /// The `keys[i]` represent the key for `dataList[i]`.
  Future<dynamic> transaction({
    @required String path,
    @required StoreRef store,
    @required List keys,
    @required List dataList,
  }) {
    final Map<String, dynamic> message = {
      "path": path,
      "store": store,
      "keys": keys,
      "dataList": dataList,
    };

    assert(message["path"] is String);
    assert(message["store"] is StoreRef);
    assert(message["keys"] is List);
    assert(message["dataList"] is List);
    assert((message["keys"] as List).length ==
        (message["dataList"] as List).length);

    _log.fine("recording list of data");

    return compute<Map<String, dynamic>, dynamic>(_isolateTransaction, message);
  }

  /// Finds the records that match the [finder] in the [store] for the
  /// database in an isolate.
  ///
  /// Returns an empty list if no data can be found.
  Future<List> find({
    @required String path,
    @required StoreRef store,
    @required Finder finder,
  }) {
    final Map<String, dynamic> message = {
      "path": path,
      "store": store,
      "finder": finder,
    };

    assert(message["path"] is String);
    assert(message["store"] is StoreRef);
    assert(message["finder"] is Finder);

    _log.fine("finding data");

    return compute<Map<String, dynamic>, List>(_isolateFind, message);
  }

  /// Finds the first record that matches the [finder] in the [store] for the
  /// database in an isolate.
  ///
  /// Returns `null` if no data can be found.
  Future<dynamic> findFirst({
    @required String path,
    @required StoreRef store,
    @required Finder finder,
  }) {
    final Map<String, dynamic> message = {
      "path": path,
      "store": store,
      "finder": finder,
    };

    assert(message["path"] is String);
    assert(message["store"] is StoreRef);
    assert(message["finder"] is Finder);

    _log.fine("finding first data");

    return compute<Map<String, dynamic>, dynamic>(_isolateFindFirst, message);
  }
}

Future<dynamic> _isolateRecord(Map<String, dynamic> message) async {
  final String path = message["path"];
  final StoreRef store = message["store"];
  final key = message["key"];
  final data = message["data"];

  final Database db = await databaseFactoryIo.openDatabase(path);

  return store.record(key).put(db, data);
}

Future<dynamic> _isolateTransaction(Map<String, dynamic> message) async {
  final String path = message["path"];
  final StoreRef store = message["store"];
  final List keys = message["keys"];
  final List dataList = message["dataList"];

  final Database db = await databaseFactoryIo.openDatabase(path);

  return db.transaction((transaction) async {
    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final data = dataList[i];

      await store.record(key).put(transaction, data);
    }
  });
}

Future<List> _isolateFind(Map<String, dynamic> message) async {
  final String path = message["path"];
  final StoreRef store = message["store"];
  final Finder finder = message["finder"];

  final Database db = await databaseFactoryIo.openDatabase(path);

  return store
      .find(db, finder: finder)
      .then((records) => records.map((record) => record.value).toList());
}

Future<dynamic> _isolateFindFirst(Map<String, dynamic> message) async {
  final String path = message["path"];
  final StoreRef store = message["store"];
  final Finder finder = message["finder"];

  final Database db = await databaseFactoryIo.openDatabase(path);

  return store.findFirst(db, finder: finder).then((record) => record?.value);
}

Future<bool> _isolateDrop(String path) async {
  try {
    Directory(path).deleteSync(recursive: true);
    return true;
  } catch (e, st) {
    Logger("IsolateDrop").warning("error while dropping database", e, st);
    return false;
  }
}
