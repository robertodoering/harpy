import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

/// The [DirectoryServiceData] is used to construct a [DirectoryService] for
/// isolates.
class DirectoryServiceData {
  String path;
}

class DirectoryService {
  DirectoryService();

  /// Constructs a [DirectoryService] from the [DirectoryServiceData].
  ///
  /// Used by isolates.
  DirectoryService.data(this.data);

  static final Logger _log = Logger("DirectoryService");

  /// Instance that can be used in isolates.
  static DirectoryService isolateInstance;

  DirectoryServiceData data = DirectoryServiceData();

  Future<void> init() async {
    _log.fine("initializing temporary directory");
    final Directory dir = await getTemporaryDirectory();
    data.path = dir.path;
    _log.fine("got path: ${dir.path}");
  }

  /// Gets the path for [fileName] inside the [bucket].
  String filePath(String bucket, String fileName) {
    return "${data.path}/$bucket/$fileName";
  }

  /// Creates a [File] inside the [bucket] with the [name].
  ///
  /// If [override] is `true` any existing file with the same [name] inside the
  /// [bucket] will be overridden with the new [content].
  /// Else the [File] will stay untouched.
  ///
  /// todo: error handling if unable to create files
  File createFile({
    @required String bucket,
    @required String name,
    @required String content,
    bool override = true,
  }) {
    final file = File(filePath(bucket, name));

    // delete the file if it already exists and should be overridden
    if (file.existsSync() && override) {
      file.deleteSync();
    }

    file
      ..createSync(recursive: true)
      ..writeAsStringSync(content, flush: true);

    return file;
  }

  /// Returns the [File] inside the [bucket] with the [name].
  ///
  /// If the [File] does not exists it will return `null`.
  File getFile({
    @required String bucket,
    @required String name,
  }) {
    final file = File(filePath(bucket, name));

    return file.existsSync() ? file : null;
  }

  /// Lists all [File]s inside the [bucket].
  ///
  /// If [extension] is not `null` it will only return [File]s with the
  /// [extension].
  List<File> listFiles({
    @required String bucket,
    String extension,
  }) {
    _log.fine("listing all files in bucket: $bucket");
    final files = <File>[];
    final directory = Directory("${data.path}/$bucket");

    if (directory.existsSync()) {
      for (FileSystemEntity entity in directory.listSync()) {
        if (extension == null || entity.path.endsWith(extension)) {
          files.add(entity);
        }
      }
    }

    return files;
  }

  /// Clears all cached files in the temporary directory.
  int clearCache() {
    final directory = Directory("${data.path}/");
    try {
      final int files = directory.listSync(recursive: true).length;
      directory.deleteSync(recursive: true);
      return files;
    } on FileSystemException {
      return 0;
    }
  }
}
