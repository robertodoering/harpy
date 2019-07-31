import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

abstract class HarpyDatabase {
  Database db;

  /// The name of the database.
  String get name;

  /// The [subDirectory] determines where the database is located.
  String subDirectory;

  static final Logger _log = Logger("Database");

  Future<void> initialize() async {
    _log.fine("initializing database with subDirectory: $subDirectory");

    assert(subDirectory != null);

    final directory = await getTemporaryDirectory();
    final path = directory.path;

    db = await databaseFactoryIo.openDatabase(
      "$path/database/$name",
      version: 1,
    );
  }
}
