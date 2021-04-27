import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:harpy/core/core.dart';
import 'package:permission_handler/permission_handler.dart';

/// Uses the [FlutterDownloader] to download files in the background with a
/// status notification.
///
/// Files are downloaded into the download directory using
/// [DownloadsPathProvider].
///
/// To write into the download directory, additional permissions have to be
/// granted at runtime.
///
/// See https://pub.dev/packages/flutter_downloader.
/// See https://pub.dev/packages/downloads_path_provider.
class DownloadService {
  MessageService get messageService => app<MessageService>();

  Future<void> initialize() async {
    await FlutterDownloader.initialize(debug: !kReleaseMode);
    // register an empty callback to fix an issue in the flutter_download
    // package
    FlutterDownloader.registerCallback(_emptyCallback);
  }

  Future<void> download({
    @required String url,
    String name,
  }) async {
    final Directory directory = await _requestDownloadDirectory();

    if (directory != null) {
      try {
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: directory.path,
          fileName: name,
        );

        messageService.show('download started');
      } catch (e) {
        messageService.show('download failed');
      }
    }
  }

  Future<Directory> _requestDownloadDirectory() async {
    final MessageService messageService = app<MessageService>();

    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      return DownloadsPathProvider.downloadsDirectory;
    } else {
      messageService.show('storage permission not granted');

      return null;
    }
  }
}

void _emptyCallback(String id, DownloadTaskStatus status, int progress) {}
