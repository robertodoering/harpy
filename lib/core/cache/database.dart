import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

abstract class HarpyDatabase {
  Database db;

  /// The name of the database.
  String get name;

  Future<void> initialize() async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;

    db = await databaseFactoryIo.openDatabase(
      "$path/database/$name",
      version: 1,
    );
  }
}
