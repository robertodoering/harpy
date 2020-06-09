import 'package:harpy/core/cache/database_service.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

/// A [HarpyDatabase] needs to be initialized to set the [path] that is used
/// for the [Database] object in the [DatabaseService].
abstract class HarpyDatabase {
  final DatabaseService databaseService = app<DatabaseService>();

  /// The name of the database.
  String get name;

  /// The path where the [Database] is located.
  String path;

  static final Logger _log = Logger("HarpyDatabase");

  /// Initializes the [path] with the temporary directory and an optional
  /// [subDirectory].
  Future<void> initialize({
    String subDirectory,
  }) async {
    _log.fine("initializing database $name with subDirectory: $subDirectory");

    final directory = await getTemporaryDirectory();

    path = "${directory.path}/database/$name";

    if (subDirectory != null) {
      path = "$path/$subDirectory/";
    }

    path = "$path/database";
  }

  /// Deletes this database directory.
  Future<bool> drop() async => databaseService.drop(name: name);
}
