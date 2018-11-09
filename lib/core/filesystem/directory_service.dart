import 'dart:io';

abstract class DirectoryService {
  String _path;

  Future<Directory> requestDirectory();

  Future<File> createFile(
    String bucket,
    String fileName,
    String fileExtension,
    String content, {
    bool rewrite = true,
  }) async {
    await _requestPathIfNeeded();

    File newFile = File(_getFilePath(bucket, fileName, fileExtension));
    if (newFile.existsSync()) {
      if (rewrite) {
        newFile.deleteSync();
      } else {
        return Future.error("File already exsist!");
      }
    }

    newFile.createSync(recursive: true);
    newFile.writeAsStringSync(content, flush: true);

    return newFile;
  }

  Future<String> readFile(
    String bucket,
    String fileName,
    String fileExtension,
  ) async {
    await _requestPathIfNeeded();

    File file = File(_getFilePath(bucket, fileName, fileExtension));
    return file.readAsStringSync();
  }

  Future<List<File>> listFiles(String bucket) async {
    await _requestPathIfNeeded();
    List<File> files = [];
    Directory('$path/$bucket').listSync().forEach((fileSystemEntry) {
      files.add(File(fileSystemEntry.path));
    });

    return files;
  }

  String _getFilePath(String bucket, String fileName, String fileExtension) {
    return '$path/$bucket/$fileName.$fileExtension';
  }

  void _requestPathIfNeeded() async {
    if (_path == null) {
      Directory dir = await requestDirectory();
      _path = dir.path;
    }
  }

  String get path => _path;
}
