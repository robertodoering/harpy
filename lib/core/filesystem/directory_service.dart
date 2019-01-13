import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

/// The [DirectoryServiceData] is used to construct a [DirectoryService] for
/// isolates.
class DirectoryServiceData {
  String path;
}

class DirectoryService {
  DirectoryServiceData data = DirectoryServiceData();

  static DirectoryService _instance = DirectoryService._();
  factory DirectoryService() => _instance;
  DirectoryService._();

  Future<void> init() async {
    Directory dir = await getTemporaryDirectory();
    data.path = dir.path;
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
    File file = File(filePath(bucket, name));

    // delete the file if it already exists and should be overridden
    if (file.existsSync() && override) {
      file.deleteSync();
    }

    file.createSync(recursive: true);
    file.writeAsStringSync(content, flush: true);

    return file;
  }

  /// Returns the [File] inside the [bucket] with the [name].
  ///
  /// If the [File] does not exists it will return `null`.
  File getFile({
    @required String bucket,
    @required String name,
  }) {
    File file = File(filePath(bucket, name));

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
    List<File> files = [];
    Directory directory = Directory("${data.path}/$bucket");

    if (directory.existsSync()) {
      for (FileSystemEntity entity in directory.listSync()) {
        if (extension == null || entity.path.endsWith(extension)) {
          files.add(entity);
        }
      }
    }

    return files;
  }
}
